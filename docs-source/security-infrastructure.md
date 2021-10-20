# Infrastructure security in AWS Panorama<a name="security-infrastructure"></a>

As a managed service, AWS Panorama is protected by the AWS global network security procedures that are described in the [Amazon Web Services: Overview of security processes](https://d0.awsstatic.com/whitepapers/Security/AWS_Security_Whitepaper.pdf) whitepaper\.

You use AWS published API calls to access AWS Panorama through the network\. Clients must support Transport Layer Security \(TLS\) 1\.2 or later\. Clients must also support cipher suites with perfect forward secrecy \(PFS\) such as Ephemeral Diffie\-Hellman \(DHE\) or Elliptic Curve Ephemeral Diffie\-Hellman \(ECDHE\)\. Most modern systems such as Java 7 and later support these modes\.

Additionally, requests must be signed by using an access key ID and a secret access key that is associated with an IAM principal\. Or you can use [AWS Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html) \(AWS STS\) to generate temporary security credentials to sign requests\.

The AWS Panorama Appliance needs internet access to communicate with AWS services\. It also needs access to your internal network of cameras\. It is important to consider your network configuration carefully and only provide each device the access that it needs\.

**Topics**
+ [Configuring internet access](#security-infrastructure-internet)
+ [Configuring local network access](#security-infrastructure-local)

## Configuring internet access<a name="security-infrastructure-internet"></a>

During [provisioning](gettingstarted-setup.md), you can configure the appliance to request a specific IP address\. Choose an IP address ahead of time to simplify firewall configuration and ensure that the appliance's address doesn't change if it's offline for a long period of time\.

The appliance uses multiple AWS services in addition to AWS Panorama\. Configure your firewall to allow the appliance to connect to these endpoints on port 443\.

**Internet access**
+ AWS IoT \(HTTPS and MQTT, port 443\) – AWS IoT Core and device management endpoints\. For details, see [AWS IoT Device Management endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/iot_device_management.html) in the Amazon Web Services General Reference\.
+ **Amazon CloudWatch \(HTTPS, port 443\)** – `monitoring.<region>.aws.amazon.com`\.
+ **Amazon CloudWatch Logs \(HTTPS, port 443\)** – `logs.<region>.aws.amazon.com`\.
+ **Amazon Simple Storage Service \(HTTPS, port 443\)** – `s3-accesspoint.<region>.aws.amazon.com`\.

If your application calls other AWS services, the appliance needs access to the endpoints for those services as well\. For more information, see [Service endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/aws-service-information.html)\.

## Configuring local network access<a name="security-infrastructure-local"></a>

The appliance needs access to RTSP video streams locally, but not over the internet\. Configure your firewall to allow the appliance to access RTSP streams on port 554 internally, and to not allow streams to go out to or come in from the internet\. 

**Local access**
+ **Real\-time streaming protocol \(RTSP, port 554\)** – To read camera streams\.
+ **Network time protocol \(NTP, port 123\)** – To keep the appliance's clock in sync\. If you don't run an NTP server on your network, the appliance can also connect to public NTP servers over the internet\.