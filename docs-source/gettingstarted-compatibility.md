# Supported computer vision models and cameras<a name="gettingstarted-compatibility"></a>

AWS Panorama integrates with Amazon SageMaker to support importing and compiling computer vision models for AWS Panorama applications\. You can start with a provided model, or build your own model with a supported framework\. You can import a model from an Amazon Simple Storage Service \(Amazon S3\) bucket or from the output of a SageMaker job\.

To process video and get images to send to a model, the AWS Panorama Appliance connects to an H\.264 encoded video stream with the RTSP protocol\. AWS Panorama tests a variety of common cameras for compatibility\.

**Topics**
+ [Supported models](#gettingstarted-compatibility-models)
+ [Supported cameras](#gettingstarted-compatibility-cameras)

## Supported models<a name="gettingstarted-compatibility-models"></a>

When you deploy an application, AWS Panorama uses the SageMaker Neo compiler to compile it\. SageMaker Neo is a compiler that optimizes models to run efficiently on edge devices such as the AWS Panorama Appliance\. AWS Panorama supports the versions of PyTorch, Apache MXNet, and TensorFlow that are supported for edge devices by SageMaker Neo\.

**Note**  
For a list of models that have been tested with AWS Panorama, see [Model compatibility](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/resources/model-compatibility.md)\.

For more information, see the following topics:

****
+ [Compile and deploy models with Amazon SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html)
+ [SageMaker Neo supported frameworks and operators](https://aws.amazon.com/releasenotes/sagemaker-neo-supported-frameworks-and-operators/)
+ [Computer vision models](applications-models.md)

## Supported cameras<a name="gettingstarted-compatibility-cameras"></a>

The AWS Panorama Appliance supports H\.264 video streams from cameras that output RTSP over a local network\. The following camera models have been tested for compatibility with the AWS Panorama Appliance\.
+ [Anpviz](https://anpvizsecurity.com/) – IPC\-B850W\-S\-3X, IPC\-D250W\-S
+ [Axis](https://www.axis.com/) – M3057\-PLVE, M3058\-PLVE, P1448\-LE, P3225\-LV Mk II
+ [LaView](https://www.laviewsecurity.com/) – LV\-PB3040W
+ [Vivotek](https://www.vivotek.com/) – IB9360\-H
+ **WGCC** – Dome PoE 4MP ONVIF

For the appliance's hardware specifications, see [AWS Panorama Appliance Developer Kit specifications](gettingstarted-hardware.md)\.