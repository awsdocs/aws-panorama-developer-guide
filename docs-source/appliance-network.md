# Connecting the AWS Panorama Appliance to your network<a name="appliance-network"></a>

The AWS Panorama Appliance requires connectivity to both the AWS cloud and your on\-premises network of IP cameras\. You can connect the appliance to a single firewall that grants access to both, or connect each of the device's two network interfaces to a different subnet\. In either case, you must secure the appliance's network connections to prevent unauthorized access to your camera streams\.

**Topics**
+ [Single network configuration](#appliance-network-single)
+ [Dual network configuration](#appliance-network-dual)
+ [Configuring internet access](#security-infrastructure-internet)
+ [Configuring local network access](#security-infrastructure-local)

## Single network configuration<a name="appliance-network-single"></a>

The appliance has two Ethernet ports\. If you route all traffic to and from the device through a single router, you can use the second port for redundancy in case the physical connection to the first port is broken\. Configure your router to allow the appliance to connect only to camera streams and the internet, and to block camera streams from otherwise leaving your internal network\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/networking-single.png)

For details on the ports and endpoints that the appliance needs access to, see [Configuring internet access](#security-infrastructure-internet) and [Configuring local network access](#security-infrastructure-local)\.

## Dual network configuration<a name="appliance-network-dual"></a>

For an extra layer of security, you can place the appliance in an internet\-connected network separate from your camera network\. A firewall between your restricted camera network and the appliance's network only allows the appliance to access video streams\. If your camera network was previously air\-gapped for security purposes, you might prefer this method over connecting the camera network to a router that also grants access to the internet\.

The following example shows the appliance connecting to a different subnet on each port\. The router places the `eth0` interface on a subnet that routes to the camera network, and `eth1` on a subnet that routes to the internet\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/networking-dual.png)

You can confirm the IP address and MAC address of each port in the AWS Panorama console\.

## Configuring internet access<a name="security-infrastructure-internet"></a>

During [provisioning](gettingstarted-setup.md), you can configure the appliance to request a specific IP address\. Choose an IP address ahead of time to simplify firewall configuration and ensure that the appliance's address doesn't change if it's offline for a long period of time\.

The appliance uses multiple AWS services in addition to AWS Panorama\. Configure your firewall to allow the appliance to connect to these endpoints on port 443\.

**Internet access**
+ **AWS IoT \(HTTPS and MQTT, port 443\)** – AWS IoT Core and device management endpoints\. For details, see [AWS IoT Device Management endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/iot_device_management.html) in the Amazon Web Services General Reference\.
+ **Amazon CloudWatch \(HTTPS, port 443\)** – `monitoring.<region>.aws.amazon.com`\.
+ **Amazon CloudWatch Logs \(HTTPS, port 443\)** – `logs.<region>.aws.amazon.com`\.
+ **Amazon Simple Storage Service \(HTTPS, port 443\)** – `s3-accesspoint.<region>.aws.amazon.com`\.

If your application calls other AWS services, the appliance needs access to the endpoints for those services as well\. For more information, see [Service endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/aws-service-information.html)\.

## Configuring local network access<a name="security-infrastructure-local"></a>

The appliance needs access to RTSP video streams locally, but not over the internet\. Configure your firewall to allow the appliance to access RTSP streams on port 554 internally, and to not allow streams to go out to or come in from the internet\. 

**Local access**
+ **Real\-time streaming protocol \(RTSP, port 554\)** – To read camera streams\.
+ **Network time protocol \(NTP, port 123\)** – To keep the appliance's clock in sync\. If you don't run an NTP server on your network, the appliance can also connect to public NTP servers over the internet\.