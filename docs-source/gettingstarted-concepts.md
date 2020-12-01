# Concepts<a name="gettingstarted-concepts"></a>

In AWS Panorama, you create computer vision applications and deploy them to the AWS Panorama Appliance to analyze video streams from network cameras\. You write application code in Python and import machine learning models from Amazon SageMaker or Amazon Simple Storage Service \(Amazon S3\)\. Applications use the AWS Panorama Application SDK to receive video input from a datasource and output it to a data sink\.

**Topics**
+ [The AWS Panorama Appliance](#gettingstarted-concepts-appliance)
+ [Applications](#gettingstarted-concepts-application)
+ [Models](#gettingstarted-concepts-model)

## The AWS Panorama Appliance<a name="gettingstarted-concepts-appliance"></a>

The AWS Panorama Appliance is the hardware that runs your applications\. You use the AWS Panorama console to register an appliance, update its software, and deploy applications to it\. The software on the AWS Panorama Appliance discovers and connects to camera streams, sends frames of video to your application, and displays video output on an attached display\.

The AWS Panorama Appliance is an *edge device*\. Instead of sending images to the AWS Cloud for processing, it runs applications locally on optimized hardware\. This enables you to analyze video in real time and process the results with limited connectivity\. The appliance requires an internet connection to report its status, to upload logs, and to get software updates and deployments\.

For more information, see [Managing the AWS Panorama Appliance](panorama-appliance.md)\.

## Applications<a name="gettingstarted-concepts-application"></a>

Applications run on the AWS Panorama Appliance to do computer vision tasks on video streams\. You can build computer vision applications by combining Python code and machine learning models, and deploy them to the AWS Panorama Appliance over the internet\. Applications can output video to an attached display, or use the AWS SDK to send results to AWS services\.

For more information, see [Building AWS Panorama applications](panorama-applications.md)\.

## Models<a name="gettingstarted-concepts-model"></a>

A computer vision model is a software program that is trained to detect objects in images\. A model learns to recognize a set of objects by analyzing images of those objects\. It takes an image as input and outputs information about objects that it detects\.

AWS Panorama supports models built with PyTorch, Apache MXNet, and TensorFlow\. You can build models with Amazon SageMaker and import them from a SageMaker job or an Amazon Simple Storage Service \(Amazon S3\) bucket\. For more information, see [Computer vision models](applications-models.md)\.