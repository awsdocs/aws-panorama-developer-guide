import panoramasdk
import cv2
import numpy as np
import boto3
import time
import os
import logging
HEIGHT = 512
WIDTH = 512

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

class people_counter(panoramasdk.base):

    def interface(self):
        return {
            "parameters":
                (
                    ("float", "threshold", "Minimum confidence for display", 0.50),
                    ("model", "people_counter", "Name of the model in AWS Panorama", "aws-panorama-sample-model"),
                    ("int", "batch_size", "Model batch size", 1),
                    ("float", "person_index", "The index of the person class in the model's dataset", 14),
                ),
            "inputs":
                (
                    ("media[]", "video_in", "Camera input stream"),
                ),
            "outputs":
                (
                    ("media[video_in]", "video_out", "Video output stream"),
                )
        }


    def init(self, parameters, inputs, outputs):
        try:
            self.threshold = parameters.threshold
            self.person_index = parameters.person_index
            self.frame_num = 0
            self.inference_time_ms = 0
            self.inference_time_max = 0
            self.frame_time_ms = 0
            self.frame_time_max = 0
            self.epoch_frames = 150
            self.epoch_start = time.time()
            self.number_people = 0
            self.colours = np.random.rand(32, 3)
            self.buffered_media = {}
            self.buffered_image = {}
            # Load model
            logger.info("Loading model: " + parameters.people_counter)
            self.model = panoramasdk.model()
            self.model.open(parameters.people_counter, 1)
            os.environ['TVM_TENSORRT_USE_FP16'] = '1'
            # Create input and output arrays
            class_info = self.model.get_output(0)
            prob_info = self.model.get_output(1)
            rect_info = self.model.get_output(2)
            self.class_array = np.empty(class_info.get_dims(), dtype=class_info.get_type())
            self.prob_array = np.empty(prob_info.get_dims(), dtype=prob_info.get_type())
            self.rect_array = np.empty(rect_info.get_dims(), dtype=rect_info.get_type())
            logger.info("Initialization complete")
            return True

        except Exception as e:
            logger.error("Exception: {}".format(e))
            return False

    def entry(self, inputs, outputs):
        frame_start = time.time()
        self.frame_num += 1
        # Loop through attached video streams
        for i in range(len(inputs.video_in)):
            outputs.video_out[i] = self.process_media(inputs.video_in[i])
        # Log metrics
        frame_time = (time.time() - frame_start) * 1000
        if frame_time > self.frame_time_max:
            self.frame_time_max = frame_time
        self.frame_time_ms += frame_time
        if self.frame_num % self.epoch_frames == 0:
            epoch_time = time.time() - self.epoch_start
            logger.info('epoch length: {:.3f} s ({:.3f} FPS)'.format(epoch_time, self.epoch_frames/epoch_time))
            logger.info('avg inference time: {:.3f} ms'.format(self.inference_time_ms / self.epoch_frames / len(inputs.video_in)))
            logger.info('max inference time: {:.3f} ms'.format(self.inference_time_max))
            logger.info('avg frame processing time: {:.3f} ms'.format(self.frame_time_ms / self.epoch_frames))
            logger.info('max frame processing time: {:.3f} ms'.format(self.frame_time_max))
            self.inference_time_ms = 0
            self.inference_time_max = 0
            self.frame_time_ms = 0
            self.frame_time_max = 0
            self.epoch_start = time.time()
        return True

    def process_media(self, media):
        stream = media.stream_uri
        # Set up stream buffer
        if not self.buffered_media.get(stream):
            self.buffered_media[stream] = media
            self.buffered_image[stream] = self.preprocess(media.image)
            logger.info('Set up frame buffer for stream: {}'.format(stream))
            logger.info('Stream image size: {}'.format(media.image.shape))
        output = self.buffered_media[stream]
        # Run inference on the buffered image
        inference_start = time.time()
        self.model.batch(0, self.buffered_image[stream])
        self.model.flush()
        # While waiting for inference, preprocess the current image
        self.buffered_image[stream] = self.preprocess(media.image)
        self.buffered_media[stream] = media
        resultBatchSet = self.model.get_result()
        inference_time = (time.time() - inference_start) * 1000
        if inference_time > self.inference_time_max:
            self.inference_time_max = inference_time
        self.inference_time_ms += inference_time
        # Process results
        #   Model outputs (classes, probabilities, bounding boxes) are collected in 
        #   the BatchSet returned by model.get_result
        #   Each output is a Batch of arrays, one for each input in the batch
        classes = resultBatchSet.get(0)
        probabilities = resultBatchSet.get(1)
        boxes = resultBatchSet.get(2)
        # Each batch only has one image; save results for that image 
        classes.get(0, self.class_array)
        probabilities.get(0, self.prob_array)
        boxes.get(0, self.rect_array)
        # Get indices of people in class array
        person_indices = self.get_number_persons(self.class_array[0],self.prob_array[0])
        self.number_people = len(person_indices)
        # Draw bounding boxes on output image
        for index in person_indices:
            left = np.clip(self.rect_array[0][index][0] / np.float(HEIGHT), 0, 1)
            top = np.clip(self.rect_array[0][index][1] / np.float(WIDTH), 0, 1)
            right = np.clip(self.rect_array[0][index][2] / np.float(HEIGHT), 0, 1)
            bottom = np.clip(self.rect_array[0][index][3] / np.float(WIDTH), 0, 1)
            output.add_rect(left, top, right, bottom)
            output.add_label(str(self.prob_array[0][index][0]), right, bottom)
        # Add text
        output.add_label('People detected: {}'.format(self.number_people), 0.02, 0.9)
        self.model.release_result(resultBatchSet)
        return output

    def preprocess(self, img):
        resized = cv2.resize(img, (HEIGHT, WIDTH))
        mean = [0.485, 0.456, 0.406]
        std = [0.229, 0.224, 0.225]
        img = resized.astype(np.float32) / 255.
        img_a = img[:, :, 0]
        img_b = img[:, :, 1]
        img_c = img[:, :, 2]
        # Normalize data in each channel
        img_a = (img_a - mean[0]) / std[0]
        img_b = (img_b - mean[1]) / std[1]
        img_c = (img_c - mean[2]) / std[2]
        # Put the channels back together
        x1 = [[[], [], []]]
        x1[0][0] = img_a
        x1[0][1] = img_b
        x1[0][2] = img_c
        return np.asarray(x1)
    
    def get_number_persons(self, class_data, prob_data):
        # Filter out results beneath confidence threshold
        person_indices = [i for i in range(len(class_data)) if int(class_data[i]) == self.person_index]
        prob_person_indices = [i for i in person_indices if prob_data[i] >= self.threshold]
        return prob_person_indices

def main():
    people_counter().run()

main()
