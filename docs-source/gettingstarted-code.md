# AWS Panorama sample application features<a name="gettingstarted-code"></a>

A sample application that demonstrates the use of the AWS Panorama Application SDK is available in this guide's [GitHub repository](https://github.com/awsdocs/aws-panorama-developer-guide)\. You can run the sample application by following [the previous topic](gettingstarted-deploy.md) or by using the command\-line scripts and instructions in [the project's README file](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample)\.

The sample application uses a computer vision model to detect people in single frames of video\. When it detects one or more people, it draws an overlay on the image that indicates where the people are and how many people are detected\. The application can process multiple video streams\. It outputs a video stream that shows the original video or videos with overlays on top\.

The following diagram shows the major components of the application running on an AWS Panorama Appliance Developer Kit\. The application code uses the AWS Panorama Application SDK to get images and interact with the model, which it doesn't have direct access to\. The application outputs video to a connected display but does not send image data outside of your local network\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/sample-app.png)

To simplify deploying and managing the application, the project includes a AWS CloudFormation template that uses AWS Serverless Application Model \(AWS SAM\) to create an AWS Lambda function and its runtime role\. It also includes shell scripts that create a bucket, upload the model, deploy the application, and clean up everything when you're done\.

**Note**  
For more sample code, see the [aws\-panorama\-samples](https://github.com/aws-samples/aws-panorama-samples) repository on GitHub\.

The following sections describe features of the sample application and highlight relevant selections of code\. The code examples are abbreviated for clarity\. For the full application code, see the linked source files in GitHub\.

**Topics**
+ [Loading a model](#gettingstarted-code-initialization)
+ [Detecting objects](#gettingstarted-code-inference)
+ [Preprocessing images](#gettingstarted-code-preprocessing)
+ [Processing results](#gettingstarted-code-results)

## Loading a model<a name="gettingstarted-code-initialization"></a>

During initialization, the application uses the AWS Panorama Application SDK to load a machine learning model\. First, it creates a model object by calling `panoramasdk.model()`\. Then, it uses the `open` method to load the model by name\.

**Example [lambda\_function\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/code/lambda_function.py) – Initialization**  

```
    def init(self, parameters, inputs, outputs):
        try:
            self.threshold = parameters.threshold
            self.person_index = parameters.person_index
            self.frame_num = 0
            ...
            # Load model
            logger.info("Loading model: " + parameters.model_name)
            self.model = panoramasdk.model()
            self.model.open(parameters.model_name, 1)
            # Use 16-bit precision for faster inference
            os.environ['TVM_TENSORRT_USE_FP16'] = '1'
            # Create input and output arrays
            class_info = self.model.get_output(0)
            prob_info = self.model.get_output(1)
            rect_info = self.model.get_output(2)
            self.class_array = np.empty(class_info.get_dims(), dtype=class_info.get_type())
            self.prob_array = np.empty(prob_info.get_dims(), dtype=prob_info.get_type())
            self.rect_array = np.empty(rect_info.get_dims(), dtype=rect_info.get_type())
```

When you deploy the application, you create the model resource in the AWS Panorama console and name it `aws-panorama-sample-model`\. This is the default value for the `model_name` parameter\. To increase inference speed, the [TVM\_TENSORRT\_USE\_FP16](https://neo-ai-dlr.readthedocs.io/en/latest/tensorrt.html#automatic-fp16-conversion) configures the appliance to use 16\-bit floating\-point numbers instead of 32\-bit\. You can omit this setting if your model performs well without it\.

## Detecting objects<a name="gettingstarted-code-inference"></a>

The application starts by calling the `run` method that it inherits from `awspanoramasdk.base`\. This method calls the `entry` method and passes it frames of video from one or more camera streams \(`video_in`\)\. The application loops over frames of video, detects people, and outputs the original video with an overlay that includes the number of people detected, and bounding boxes around each person\.

**Example [lambda\_function\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/code/lambda_function.py) – Inference**  

```
class people_counter(panoramasdk.base):
    ...
    def entry(self, inputs, outputs):
        self.frame_num += 1
        # Loop through attached video streams
        for i in range(len(inputs.video_in)):
            outputs.video_out[i] = self.process_media(inputs.video_in[i])
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
        self.model.batch(0, self.buffered_image[stream])
        self.model.flush()
        # While waiting for inference, preprocess the current image
        self.buffered_image[stream] = self.preprocess(media.image)
        self.buffered_media[stream] = media
        # Wait for inference results
        inference_results = self.model.get_result()
        # Process results
        output = self.process_results(inference_results, output)
        self.model.release_result(inference_results)
        return output
...
def main():
    people_counter().run()

main()
```

The application stores the latest frame of video from each stream in a buffer\. While it runs inference to detect objects on the previous image, the application prepares the new image for inference in parallel\. Between calls to `model.flush()` and `model.get_result()`, the model is running inference asynchronously on the appliance's GPU\. During this time, the application can use the CPU to preprocess images, reducing the total processing time for a frame by about 15 ms\.

## Preprocessing images<a name="gettingstarted-code-preprocessing"></a>

Before the application sends an image to the model, it prepares it for inference by resizing it and normalizing color data\. The model that the application uses requires a 512 x 512 pixel image with three color channels, to match the number of inputs in its first layer\. The application adjusts each color value by converting it to a number between 0 and 1, subtracting the average value for that color, and dividing by the standard deviation\. Finally, it combines the color channels and converts it to a NumPy array that the model can process\.

**Example [lambda\_function\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/code/lambda_function.py) – Preprocessing**  

```
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
```

This process gives the model values in a predictable range centered around 0\. It matches the preprocessing applied to images in the training dataset, which is a standard approach but can vary per model\.

## Processing results<a name="gettingstarted-code-results"></a>

When the application runs inference, it sends the model only a single image at a time\. The AWS Panorama Application SDK can also process images in batches, so it takes a batch as input and sends results in batches\. The *batch set* contains a batch of results for each output from the model\.

The sample model returns three outputs: a list of objects detected, a list of probabilities for those objects, and a list of bounding boxes\. The application gets the batch for each output, and then the list for the first image in each batch\. It finds people among those objects, and updates the output image accordingly\.

**Example [lambda\_function\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/code/lambda_function.py) – Process results**  

```
    def process_results(self, batch_set, output_media):
        # Model outputs (classes, probabilities, bounding boxes) are collected in
        # the BatchSet returned by model.get_result
        # Each output is a Batch of arrays, one for each input in the batch
        classes = batch_set.get(0)
        probabilities = batch_set.get(1)
        boxes = batch_set.get(2)
        # Each batch has only one image; save results for that image
        classes.get(0, self.class_array)
        probabilities.get(0, self.prob_array)
        boxes.get(0, self.rect_array)
        # Get indices of people in class array
        person_indices = [i for i in range(len(self.class_array[0])) if int(self.class_array[0][i]) == self.person_index]
        # Filter out results beneath confidence threshold
        prob_person_indices = [i for i in person_indices if self.prob_array[0][i] >= self.threshold]
        # Draw bounding boxes on output image
        for index in prob_person_indices:
            left = np.clip(self.rect_array[0][index][0] / np.float(HEIGHT), 0, 1)
            top = np.clip(self.rect_array[0][index][1] / np.float(WIDTH), 0, 1)
            right = np.clip(self.rect_array[0][index][2] / np.float(HEIGHT), 0, 1)
            bottom = np.clip(self.rect_array[0][index][3] / np.float(WIDTH), 0, 1)
            output_media.add_rect(left, top, right, bottom)
            output_media.add_label(str(self.prob_array[0][index][0]), right, bottom)
        # Add text
        output_media.add_label('People detected: {}'.format(len(prob_person_indices)), 0.02, 0.9)
        return output_media
```