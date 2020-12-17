# Building AWS Panorama applications<a name="panorama-applications"></a>

Applications run on the AWS Panorama Appliance to do computer vision tasks on video streams\. You can build computer vision applications by combining Python code and machine learning models, and deploy them to the AWS Panorama Appliance over the internet\. Applications can output video to an attached display, or use the AWS SDK to send results to AWS services\.

A [model](applications-models.md) analyzes images to detect people, vehicles, and other objects\. Based on images that it has previously seen, the model tells you what it thinks something is, and how confident it is in its guess\. You can train models with your own image data or get started with a sample\.

The application's [code](applications-code.md) loads a model, sends still images to it, and processes the result\. A model might detect multiple objects and return their shape and location\. The code can use this information to draw overlays on the video or send results to an AWS service for storage or further processing\.

To get images from a stream, interact with a model, and output video, application code uses [the AWS Panorama Application SDK](applications-panoramasdk.md)\. The application SDK is a Python library that supports models generated with PyTorch, Apache MXNet, and TensorFlow\.

**Topics**
+ [Managing applications and application versions in AWS Panorama](applications-manage.md)
+ [Computer vision models](applications-models.md)
+ [Authoring application code](applications-code.md)
+ [AWS SDK for Python \(Boto3\)](applications-awssdk.md)
+ [Adding text and boxes to output video](applications-overlays.md)
+ [The AWS Panorama Application SDK](applications-panoramasdk.md)