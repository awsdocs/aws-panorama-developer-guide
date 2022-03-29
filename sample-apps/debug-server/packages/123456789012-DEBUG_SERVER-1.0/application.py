import json
import logging
import os
import threading
import time
from logging.handlers import RotatingFileHandler

import boto3
from botocore.exceptions import ClientError
from botocore.exceptions import CredentialRetrievalError
import cv2
import numpy as np
import panoramasdk
from http.server import HTTPServer, SimpleHTTPRequestHandler

import requests

class Application():

    def __init__(self, panorama):
        """Initializes the application's attributes with parameters from the interface, and default values."""
        self.MODEL_NODE = 'model_node'
        self.APPLICATION_NAME = 'debug-server'
        self.DEVICE_PORT = 8080
        self.CONTAINER_PORT = 80
        self.panorama = panorama
        self.frame_num = 0
        self.detected_frame = 0
        self.inference_time_ms = 0
        self.inference_time_max = 0
        self.frame_time_current = 0
        self.frame_time_ms = 0
        self.frame_time_max = 0
        self.epoch_frames = 150
        self.epoch_start = time.time()
        self.detected_class = None
        self.terminate = False
        logger.info('## ENVIRONMENT VARIABLES\r{}'.format(dict(**os.environ)))
        try:
            # get parameters from application manifest
            logger.info('Configuring parameters.')
            self.threshold = self.panorama.inputs.threshold.get()
            self.device_id = self.panorama.inputs.device_id.get()
            self.device_ip = self.panorama.inputs.device_ip.get()
            self.log_level = self.panorama.inputs.log_level.get()
            self.region = self.panorama.inputs.region.get()
            self.model_input = self.panorama.inputs.model_input_name.get()
            self.model_width = self.panorama.inputs.model_input_width.get()
            self.model_order = self.panorama.inputs.model_input_order.get()
            # configure logger
            if self.log_level in ('DEBUG','INFO','WARNING','ERROR','CRITICAL'):
                logger.setLevel(self.log_level)
            # read model classes from local file
            with open('/panorama/squeezenet_classes.json','r') as f:
                self.classes= json.load(f)
        except:
            logger.exception('Error during initialization.')
        try:
            # AWS SDK
            logger.info('Configuring AWS SDK for Python.')
            boto_session = boto3.session.Session(region_name=self.region)
            self.cloudwatch = boto_session.resource('cloudwatch')
        except CredentialRetrievalError:
            logger.warn('AWS SDK credentials are not available. Disabling metrics.')
        except:
            logger.exception('Error creating AWS SDK session.')
        finally:
            logger.info('Initialization complete.')
    # Get images from application SDK
    def process_streams(self):
        """Processes one frame of video from one or more video streams."""
        frame_start = time.time()
        self.frame_num += 1
        logger.debug(self.frame_num)
        # Loop through attached video streams
        self.streams = self.panorama.inputs.video_in.get()
        for stream in self.streams:
            self.process_media(stream)
        # Log metrics
        self.frame_time_current = (time.time() - frame_start) * 1000
        self.record_metrics()
        self.panorama.outputs.video_out.put(self.streams)
    # Preprocess images for inference
    def preprocess_image(self, img):
        """Resizes and normalizes a frame of video."""
        width = self.model_width
        resized = cv2.resize(img, (width, width))
        if self.model_order == 'CHANNEL_FIRST':
            mean = [0.485, 0.456, 0.406]
            std = [0.229, 0.224, 0.225]
            img = resized.astype(np.float32) / 255.
            # flip the image order - consolidate by color
            img_a = img[:, :, 0]
            img_b = img[:, :, 1]
            img_c = img[:, :, 2]
            # normalizing per channel data:
            img_a = (img_a - mean[0]) / std[0]
            img_b = (img_b - mean[1]) / std[1]
            img_c = (img_c - mean[2]) / std[2]
            # putting the 3 channels back together:
            x1 = [[[], [], []]]
            x1[0][0] = img_a
            x1[0][1] = img_b
            x1[0][2] = img_c
            return np.asarray(x1)
        if self.model_order == 'CHANNEL_LAST':
            # NOT NORMALIZED 
            x1 = np.asarray(resized)
            # convert to row
            x1 = np.expand_dims(x1, 0)
            return x1
    # Run inference
    def process_media(self, stream):
        """Runs inference on a frame of video."""
        logger.debug('Input image data: {}'.format(stream.image))
        logger.debug('input image shape: {}'.format(stream.image.shape))
        prep_start = time.time()
        logger.debug('Prep start')
        image_data = self.preprocess_image(stream.image)
        logger.debug('Prep complete')
        logger.debug('Prep time: {} ms'.format((time.time() - prep_start) * 1000))
        logger.debug('Preprocessed image data: {}'.format(image_data))
        logger.debug('Preprocessed image shape: {}'.format(image_data.shape))
        # Run inference
        inference_start = time.time()
        inference_results = self.panorama.call({self.model_input: image_data}, self.MODEL_NODE)
         # Log metrics
        inference_time = (time.time() - inference_start) * 1000
        logger.debug('Inference complete')
        logger.debug('Inference time: {} ms'.format((time.time() - prep_start) * 1000))
        if inference_time > self.inference_time_max:
            self.inference_time_max = inference_time
        self.inference_time_ms += inference_time
        # Process results (classification)
        self.process_results(inference_results, stream)
    # Process inference results
    def process_results(self, inference_results, stream):
        """Processes output tensors from a computer vision model and annotates a video frame."""
        """ inference_results is a tuple with a numpy array for each output from the model. """
        if inference_results is None:
            logger.warning("Inference results are None.")
            return
        logger.debug('Inference results: {}'.format(inference_results))
        first_output = inference_results[0]
        logger.debug('Output one type: {}'.format(type(first_output)))
        probabilities = first_output[0]
        # 1000 values for 1000 classes
        logger.debug('Result one shape: {}'.format(probabilities.shape))
        top_result = probabilities.argmax()
        logger.debug('Top result class: {}'.format(top_result))
        logger.debug('Top result probability: {}'.format(probabilities[top_result]))
        if probabilities[top_result] > self.threshold:
            self.detected_class = self.classes[top_result]
            self.detected_frame = self.frame_num
        # persist for up to 5 seconds
        if self.frame_num - self.detected_frame < 75:
            label = '{} ({}%)'.format(self.detected_class, int(probabilities[top_result]))
            stream.add_label(label, 0.1, 0.1)
            stream.add_rect(0,0,1,1)
    # Track performance metrics
    def record_metrics(self):
        """Record current frame time and send metrics to CloudWatch"""
        if self.frame_time_current > self.frame_time_max:
            self.frame_time_max = self.frame_time_current
        self.frame_time_ms += self.frame_time_current
        # If the epoch is not over, exit
        if self.frame_num % self.epoch_frames != 0:
            return
        # Otherwise, send metrics to CloudWatch
        epoch_time = time.time() - self.epoch_start
        epoch_fps = self.epoch_frames/epoch_time
        avg_inference_time = self.inference_time_ms / self.epoch_frames / len(self.streams)
        max_inference_time = self.inference_time_max
        avg_frame_processing_time = self.frame_time_ms / self.epoch_frames
        max_frame_processing_time = self.frame_time_max
        logger.info('epoch length: {:.3f} s ({:.3f} FPS)'.format(epoch_time, epoch_fps))
        logger.info('avg inference time: {:.3f} ms'.format(avg_inference_time))
        logger.info('max inference time: {:.3f} ms'.format(max_inference_time))
        logger.info('avg frame processing time: {:.3f} ms'.format(avg_frame_processing_time))
        logger.info('max frame processing time: {:.3f} ms'.format(max_frame_processing_time))
        self.inference_time_ms = 0
        self.inference_time_max = 0
        self.frame_time_ms = 0
        self.frame_time_max = 0
        self.epoch_start = time.time()
        self.put_metric_data('AverageInferenceTime', avg_inference_time)
        self.put_metric_data('AverageFrameProcessingTime', avg_frame_processing_time)
    # Send metrics to CloudWatch
    def put_metric_data(self, metric_name, metric_value):
        """Sends a performance metric to CloudWatch."""
        namespace = 'AWSPanoramaApplication'
        dimension_name = 'Application Name'
        dimension_value = self.APPLICATION_NAME
        try:
            metric = self.cloudwatch.Metric(namespace, metric_name)
            metric.put_data(
                Namespace=namespace,
                MetricData=[{
                    'MetricName': metric_name,
                    'Value': metric_value,
                    'Unit': 'Milliseconds',
                    'Dimensions': [
                        {
                            'Name': dimension_name,
                            'Value': dimension_value
                        },
                        {
                            'Name': 'Device ID',
                            'Value': self.device_id
                        }
                    ]
                }]
            )
            logger.info("Put data for metric %s.%s", namespace, metric_name)
        except ClientError:
            logger.warning("Couldn't put data for metric %s.%s", namespace, metric_name)
        except AttributeError:
            logger.warning("CloudWatch client is not available.")
    # Processing loop
    def run_cv(self):
        """Run computer vision workflow in a loop."""
        logger.info("PROCESSING STREAMS")
        while not self.terminate:
            try:
                self.process_streams()
                # turn off debug logging after 15 loops
                if logger.getEffectiveLevel() == logging.DEBUG and self.frame_num == 15:
                    logger.setLevel(logging.INFO)
            except:
                logger.exception('Exception on processing thread.')
        # Stop signal received
        logger.info("SHUTTING DOWN SERVER")
        self.server.shutdown()
        self.server.server_close()
        logger.info("EXITING RUN THREAD")
    # HTTP debug server
    def run_debugger(self):
        """Process debug commands from local network."""
        class ServerHandler(SimpleHTTPRequestHandler):
            # Store reference to application
            application = self
            # Get status
            def do_GET(self):
                """Process GET requests."""
                logger.info('Get request to {}'.format(self.path))
                if self.path == "/status":
                    self.send_200('OK')
                else:
                    self.send_error(400)
            # Restart application
            def do_POST(self):
                """Process POST requests."""
                logger.info('Post request to {}'.format(self.path))
                if self.path == '/restart':
                    self.send_200('OK')
                    ServerHandler.application.stop()
                else:
                    self.send_error(400)
            # Send response
            def send_200(self, msg):
                """Send 200 (success) response with message."""
                self.send_response(200)
                self.send_header('Content-Type', 'text/plain')
                self.end_headers()
                self.wfile.write(msg.encode('utf-8'))
        try:
            # Run HTTP server
            self.server = HTTPServer(("", self.CONTAINER_PORT), ServerHandler)
            self.server.serve_forever(1)
            # Server shut down by run_cv loop
            logger.info("EXITING SERVER THREAD")
        except:
            logger.exception('Exception on server thread.')
    # HTTP test client
    def run_client(self):
        """Send HTTP requests to device port to demnostrate debug server functions."""
        def client_get():
            """Get container status"""
            r = requests.get('http://{}:{}/status'.format(self.device_ip, self.DEVICE_PORT))
            logger.info('Response: {}'.format(r.text))
            return
        def client_post():
            """Restart application"""
            r = requests.post('http://{}:{}/restart'.format(self.device_ip, self.DEVICE_PORT))
            logger.info('Response: {}'.format(r.text))
            return
        # Call debug server
        while not self.terminate:
            try:
                time.sleep(30)
                client_get()
                time.sleep(300)
                client_post()
            except:
                logger.exception('Exception on client thread.')
        # stop signal received
        logger.info("EXITING CLIENT THREAD")
    # Interrupt processing loop
    def stop(self):
        """Signal application to stop processing."""
        logger.info("STOPPING APPLICATION")
        # Signal processes to stop
        self.terminate = True

def get_logger(name=__name__,level=logging.INFO):
    """Configure logger to write logs to local container path."""
    logger = logging.getLogger(name)
    logger.setLevel(level)
    LOG_PATH = '/opt/aws/panorama/logs'
    # Rotate every 10 MB and store 1 rotated log
    handler = RotatingFileHandler('{}/app.log'.format(LOG_PATH), maxBytes=10000000, backupCount=1)
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                    datefmt='%Y-%m-%d %H:%M:%S')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger

def main():
    panorama = panoramasdk.node()
    while True:
        try:
            # Instantiate application
            logger.info('INITIALIZING APPLICATION')
            app = Application(panorama)
            # Create threads for stream processing, debugger, and client
            app.run_thread = threading.Thread(target=app.run_cv)
            app.server_thread = threading.Thread(target=app.run_debugger)
            app.client_thread = threading.Thread(target=app.run_client)
            # Start threads
            logger.info('RUNNING APPLICATION')
            app.run_thread.start()
            logger.info('RUNNING SERVER')
            app.server_thread.start()
            logger.info('RUNNING CLIENT')
            app.client_thread.start()
            # Wait for threads to exit
            app.run_thread.join()
            app.server_thread.join()
            app.client_thread.join()
            logger.info('RESTARTING APPLICATION')
        except:
            logger.exception('Exception during processing loop.')

# Store logger in global variable
logger = get_logger(level=logging.INFO)
main()
