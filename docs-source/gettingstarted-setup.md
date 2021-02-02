# Setting up the AWS Panorama Appliance Developer Kit<a name="gettingstarted-setup"></a>

To get started using your AWS Panorama Appliance Developer Kit, register it in the AWS Panorama console and update its software\.

**Topics**
+ [Prerequisites](#gettingstarted-prerequisites)
+ [Register and configure the developer kit](#gettingstarted-device)
+ [Upgrade the developer kit software](#gettingstarted-upgrade)
+ [Add a camera stream](#gettingstarted-setup-camera)

## Prerequisites<a name="gettingstarted-prerequisites"></a>

To follow this tutorial, you need an AWS Panorama Appliance Developer Kit and the following hardware:

****
+ **Display** – A display with HDMI input for viewing the sample application output
+ **USB drive** \(included\) – A FAT32\-formatted USB flash memory drive with at least 1 GB of storage, for transferring an archive with configuration files and a certificate to the AWS Panorama Appliance Developer Kit
+ **Camera** – A [network\-connected camera](gettingstarted-compatibility.md#gettingstarted-compatibility-cameras) that outputs an RTSP video stream for providing input to the camera\. The developer kit can automatically discover streams from cameras that support [ONVIF Profile S](https://www.onvif.org/conformant-products/)\.

The tutorial uses a sample computer vision model and application code\. Download the model and code before you get started\.

****
+ **Model** – [ssd\_512\_resnet50\_v1\_voc\.tar\.gz](https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v0.1-preview/ssd_512_resnet50_v1_voc.tar.gz)
+ **Code** – [aws\-panorama\-sample\.zip](samples/aws-panorama-sample.zip)

The AWS Panorama console uses other AWS services to assemble application components, manage permissions, and verify settings\. To register a developer kit and deploy the sample application, you need access to the following services:

****
+ **Amazon Simple Storage Service \(Amazon S3\)** – To store model and Lambda function artifacts, and can be used for application output\.
+ **AWS Lambda** – To manage function code, configuration, and versions\.
+ **AWS Identity and Access Management \(IAM\)** – On first run, to create roles used by the AWS Panorama service, the AWS Panorama console, the AWS Panorama Appliance Developer Kit, AWS IoT Greengrass, SageMaker, and Lambda functions\.

If you don't have permission to create roles in IAM, have an administrator open [the AWS Panorama console](https://console.aws.amazon.com/panorama/home) and accept the prompt to create service roles\. For the Lambda function's permissions, you can [create an execution role with basic permissions](https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html) ahead of time, in which case you only need [permission to pass the role](https://docs.aws.amazon.com/lambda/latest/dg/access-control-identity-based.html)\.

## Register and configure the developer kit<a name="gettingstarted-device"></a>

The AWS Panorama Appliance is a hardware device that connects to network\-enabled cameras over a local network connection\. It uses a Linux\-based operating system that includes the AWS Panorama Application SDK and supporting software for running computer vision applications\.

To connect to AWS for appliance management and application deployment, the AWS Panorama Appliance Developer Kit uses device certificates\. You use the AWS Panorama console to generate certificates that authenticate the developer kit and authorize it to call AWS API operations\.

When you set up the AWS Panorama Appliance Developer Kit, enable SSH to so that you can connect to it for testing and debugging\. To enable Wi\-Fi, configure an SSID and password during setup\. Enabling Wi\-Fi does not disable Ethernet, and a wired connection is required to complete setup prior to updating the appliance's software\.

**To register an AWS Panorama Appliance Developer Kit**

1. Open the AWS Panorama console [Getting started page](https://console.aws.amazon.com/panorama/home#getting-started)\.

1. Choose **Set up appliance**\.

1. Follow the instructions to create the appliance resource, configure network access, and download an archive with the device certificate and configuration files\.

1. Copy the configuration archive to the root directory of the USB drive\.

1. Connect the USB drive to the developer kit and turn it on\.

1. The developer kit copies the configuration archive and network configuration file to itself, connects to the network, and connects to the AWS Cloud\. To continue, choose **Next**\.

1. Do not add cameras at this time\. Proceed through the remaining steps to complete setup\.

## Upgrade the developer kit software<a name="gettingstarted-upgrade"></a>

The AWS Panorama Appliance Developer Kit has several software components, including a Linux operating system, the [AWS Panorama application SDK](applications-panoramasdk.md), and supporting computer vision libraries and frameworks\. To ensure that you can use the latest features and applications with your developer kit, upgrade its software after setup and whenever an update is available\.

**To update the appliance software**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Settings**

1. Under **System software**, choose **Install version**\.

**Important**  
Before you continue, remove the USB drive from the developer kit and format it to delete its contents\. The configuration archive contains sensitive data and is not deleted automatically\.

The upgrade process can take 30 minutes or more\.

## Add a camera stream<a name="gettingstarted-setup-camera"></a>

After the software upgrade completes, add a camera stream 

If you encountered errors during setup, see [Troubleshooting](panorama-troubleshooting.md)\.

**To add a camera stream to the AWS Panorama Appliance**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Inputs**\.

1. Choose **Add camera**\.  
![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/console-device-addstream.png)

1. Choose a connection mode\. Try **Automatic** first\. If it doesn't find your camera stream, use **Manual**\.
   + **Automatic** – The AWS Panorama Appliance discovers cameras on the local network\. Choose a camera and then choose a stream to add\. If the camera has multiple streams, repeat the process to add additional streams\.
   + **Manual** – Enter the IP address of the camera and the RTSP URL of a stream\.

   Both workflows support password\-protected cameras\. 

1. Choose **Confirm**\.

Next, [create and deploy the sample application](gettingstarted-deploy.md)\.