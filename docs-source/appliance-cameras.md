# Managing camera streams in AWS Panorama<a name="appliance-cameras"></a>

To register video streams as data sources for your application, use the AWS Panorama console\. An application can process multiple streams simultaneously and multiple appliances can connect to the same stream\.

**Important**  
An application can connect to any camera stream that is routable from the local network it connects to\. To secure your video streams, configure your network to allow only RTSP traffic locally\. For more information, see [Security in AWS Panorama](panorama-security.md)\.

**To register a camera stream**

1. Open the AWS Panorama console [Data sources page](https://console.aws.amazon.com/panorama/home#data-sources)\.

1. Choose **Add data source**\.  
![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/setup-addstream.png)

1. Configure the following settings\.

****
   + **Name** – A name for the camera stream\.
   + **Description** – A short description of the camera, its location, or other details\.
   + **RTSP URL** – A URL that specifies the camera's IP address and the path to the stream\. For example, `rtsp://192.168.0.77/live/mpeg4/`
   + **Credentials** – If the camera stream is password protected, specify the username and password\.

1. Choose **Save**\.

For a list of cameras that are compatible with the AWS Panorama Appliance, see [Supported computer vision models and cameras](gettingstarted-compatibility.md)\.

## Removing a stream<a name="appliance-cameras-remove"></a>

You can delete a camera stream in the AWS Panorama console\.

**To remove a camera stream**

1. Open the AWS Panorama console [Devices page](https://console.aws.amazon.com/panorama/home#devices)\.

1. Choose an appliance\.

1. Choose **Camera streams**\.

1. Choose a stream\.

1. Choose **Remove stream**\.

Removing a camera stream from the service does not stop running applications or delete camera credentials from Secrets Manager\. To delete secrets, use the [Secrets Manager console](https://console.aws.amazon.com/secretsmanager/home#!/listSecrets)\.