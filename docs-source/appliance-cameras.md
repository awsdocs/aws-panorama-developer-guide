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

## Supported camera models<a name="appliance-cameras-models"></a>

The AWS Panorama Appliance supports H\.264 video streams from cameras that output RTSP over a local network\. The following camera models have been tested for compatibility with the AWS Panorama Appliance\.
+ [Anpviz](https://anpvizsecurity.com/) – IPC\-B850W\-S\-3X, IPC\-D250W\-S
+ [Axis](https://www.axis.com/) – M3057\-PLVE, M3058\-PLVE, P1448\-LE, P3225\-LV Mk II
+ [LaView](https://www.laviewsecurity.com/) – LV\-PB3040W
+ [Vivotek](https://www.vivotek.com/) – IB9360\-H
+ **WGCC** – Dome PoE 4MP ONVIF

For the appliance's hardware specifications, see [AWS Panorama Appliance Developer Kit specifications](gettingstarted-hardware.md)\.

## Removing a stream<a name="appliance-cameras-remove"></a>

To deregister a video stream, remove it from the appliance's inputs\.

**To remove a camera stream**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Camera streams**\.

1. Choose a stream\.

1. Choose **Remove stream**\.