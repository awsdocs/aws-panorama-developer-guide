# Network security for AWS Panorama<a name="security-network"></a>

This section provides information on network security for AWS Panorama, including network configuration for the AWS Panorama Appliance Developer Kit and AWS Panorama Appliance network activity\. 

## Network security for the AWS Panorama Appliance Developer Kit<a name="developer-kit-network-security"></a>

 The AWS Panorama Appliance Developer Kit helps you develop a proof of concept for your computer vision applications\. We recommend using the AWS Panorama Appliance Developer Kit only in a test environment\.  We don't recommend simultaneously connecting AWS Panorama to a sensitive or isolated network and an internet connected network\. Be careful if your configuration allows the AWS Panorama Appliance Developer Kit to act as a bridge to a sensitive IP camera network\. 

You are responsible for the following:
+  The physical and logical network security of the AWS Panorama Appliance Developer Kit\. 
+  Securely operating the network\-attached cameras when you use the AWS Panorama Appliance Developer Kit\. 
+  Keeping the AWS Panorama Appliance and camera software updated\. 
+  Complying with any applicable laws or regulations associated with the content of the videos and images you gather from your production environments, including those related to privacy\. 

### Network configuration for testing with non\-production data \(most secure\)<a name="network-config-without-testing"></a>

 For testing with non\-production data with the AWS Panorama Appliance Developer Kit, we recommend that you use a local IP camera and physically connect the camera to AWS Panorama Appliance using an Ethernet connection\. Then use a subnet \(isolated from your production environment\) to connect the AWS Panorama Appliance to the AWS Cloud\. 

 If a physical Ethernet connection is not possible, you can instead connect the IP camera to a hub on your subnet \(isolated from your production environment\), and use a subnet to connect the AWS Panorama Appliance Developer Kit to the AWS Cloud\. 

### Network configuration for testing with production data \(less secure\)<a name="network-config-with-test"></a>

 If you need to test production data with the AWS Panorama Appliance Developer Kit, you can use a separate Virtual Local Area Network \(VLAN\) and restrict access to the VLAN only to the camera and the AWS Panorama Appliance Developer Kit\. Use a firewall to limit incoming and outgoing traffic only to the AWS Cloud endpoints necessary for operation\. This ensures there is a one\-way communication only from the camera to the AWS Panorama Appliance Developer Kit, and isolates your test environment from any other VMS and any production environment\. 

## AWS Panorama Appliance network activity<a name="appliance-network-security"></a>

 The AWS Panorama Appliance connects to your cameras over a local Ethernet connection and uses TLS on port 443 to connect to the AWS Cloud\. The endpoint host name is not fixed, but the endpoint format is \*\.iot\.<aws\_region>\.amazonaws\.com\. For more information see [AWS IoT Core endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/iot-core.html) in the *AWS General Reference guide*\. 

AWS Panorama uses your network for the following AWS Panorama Appliance functions\.

**Application deployment**

AWS Panorama uses your network to connect to AWS IoT Greengrass and uses remote AWS IoT jobs to deploy your application to your AWS Panorama Appliance\. The AWS IoT Greengrass core manages the network activity of AWS IoT Greengrass\. For more information see [Configure the AWS IoT Greengrass core](https://docs.aws.amazon.com/greengrass/latest/developerguide/gg-core.html)\. 

**Camera identification and connection**

 When you add camera streams in Automatic connection mode, the AWS Panorama Appliance uses a remote AWS IoT job to scan your network and identify ONVIF compliant cameras on your subnet\. The AWS Panorama Appliance then uses Real\-time Streaming Protocol \(RTSP\) to connect to the video streams from IP cameras on your network\. For initial setup, you must use RTSTP on port 554 for streaming\. After initial setup, RTSP can use additional ports\.

 For more information see the RTSP [RFC 2326](https://tools.ietf.org/html/rfc2326)\. 

**Continuous monitoring**

AWS Panorama uses a remote AWS IoT job to monitor the network status and software version on your AWS Panorama Appliance\. The job runs every 30 seconds to determine whether your AWS Panorama Appliance is online and using the latest software\. 

**AWS Panorama Appliance updates**

When you request a software update or provide new credentials or configurations, AWS Panorama uses a remote AWS IoT job to send the updates to your AWS Panorama Appliance over the network\. 