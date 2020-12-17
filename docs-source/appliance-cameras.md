# Managing camera streams for an AWS Panorama Appliance<a name="appliance-cameras"></a>

To register video streams as data sources for your application, use the AWS Panorama console\. An application can process multiple streams simultaneously and multiple appliances can connect to the same stream\.

**To add a camera stream**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Camera streams**\.

1. Choose **Add camera**\.

1. Choose a connection mode\.
   + **Automatic** – The AWS Panorama Appliance discovers cameras on the local network\. Choose a camera and then choose a stream to add\. If the camera has multiple streams, repeat the process to add additional streams\.
   + **Manual** – Enter the IP address of the camera and the RTSP URL of a stream\.

   Both workflows support password\-protected cameras\.

1. Choose **Confirm**\.

**Note**  
The AWS Panorama Appliance can connect to any camera stream that is routable from the local network it connects to\. To secure your video streams, configure your network to allow only RTSP traffic locally\. For more information, see [Security in AWS Panorama](panorama-security.md)\.

For a list of cameras that are compatible with the AWS Panorama Appliance, see [Supported computer vision models and cameras](gettingstarted-compatibility.md)\.

## Removing a stream<a name="appliance-cameras-remove"></a>

To deregister a video stream, remove it from the appliance's inputs\.

**To remove a camera stream**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Camera streams**\.

1. Choose a stream\.

1. Choose **Remove stream**\.