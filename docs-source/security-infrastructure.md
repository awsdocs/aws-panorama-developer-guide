# Infrastructure security in AWS Panorama<a name="security-infrastructure"></a>

As a managed service, AWS Panorama is protected by the AWS global network security procedures that are described in the [Amazon Web Services: Overview of security processes](https://d0.awsstatic.com/whitepapers/Security/AWS_Security_Whitepaper.pdf) whitepaper\.

You use AWS published API calls to access AWS Panorama through the network\. Clients must support Transport Layer Security \(TLS\) 1\.2 or later\. Clients must also support cipher suites with perfect forward secrecy \(PFS\) such as Ephemeral Diffie\-Hellman \(DHE\) or Elliptic Curve Ephemeral Diffie\-Hellman \(ECDHE\)\. Most modern systems such as Java 7 and later support these modes\.

Additionally, requests must be signed by using an access key ID and a secret access key that is associated with an IAM principal\. Or you can use [AWS Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html) \(AWS STS\) to generate temporary security credentials to sign requests\.

## AWS Panorama Appliance network activity<a name="security-infrastructure-appliance"></a>

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