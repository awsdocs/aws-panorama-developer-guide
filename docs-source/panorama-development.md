# Building AWS Panorama applications<a name="panorama-development"></a>

Applications run on the AWS Panorama Appliance to perform computer vision tasks on video streams\. You can build computer vision applications by combining Python code and machine learning models, and deploy them to the AWS Panorama Appliance over the internet\. Applications can send video to a display, or use the AWS SDK to send results to AWS services\.

A [model](applications-models.md) analyzes images to detect people, vehicles, and other objects\. Based on images that it has seen during training, the model tells you what it thinks something is, and how confident it is in its guess\. You can train models with your own image data or get started with a sample\.

The application's [code](gettingstarted-sample.md) process still images from a camera stream, sends them to a model, and processes the result\. A model might detect multiple objects and return their shapes and location\. The code can use this information to add text or graphics to the video, or to send results to an AWS service for storage or further processing\.

To get images from a stream, interact with a model, and output video, application code uses [the AWS Panorama Application SDK](applications-panoramasdk.md)\. The application SDK is a Python library that supports models generated with PyTorch, Apache MXNet, and TensorFlow\.

**Topics**
+ [Computer vision models](applications-models.md)
+ [Building an application image](applications-image.md)
+ [Calling AWS services from your application code](applications-awssdk.md)
+ [The AWS Panorama Application SDK](applications-panoramasdk.md)
+ [Running multiple threads](applications-threading.md)
+ [Serving inbound traffic](applications-ports.md)
+ [Using the GPU](applications-gpuaccess.md)
+ [Setting up a development environment in Windows](applications-devenvwindows.md)