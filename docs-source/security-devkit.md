# Security considerations for the AWS Panorama Appliance Developer Kit<a name="security-devkit"></a>

 The AWS Panorama Appliance Developer Kit helps you develop a proof of concept for your computer vision applications\. We recommend using the AWS Panorama Appliance Developer Kit only in a test environment\. We don't recommend simultaneously connecting the developer kit to a sensitive or isolated network and a network with production camera streams\. Be careful if your configuration allows the AWS Panorama Appliance Developer Kit to act as a bridge to a sensitive IP camera network\. 

You are responsible for the following:
+  The physical and logical network security of the AWS Panorama Appliance Developer Kit\. 
+  Securely operating the network\-attached cameras when you use the AWS Panorama Appliance Developer Kit\. 
+  Keeping the AWS Panorama Appliance and camera software updated\. 
+  Complying with any applicable laws or regulations associated with the content of the videos and images you gather from your production environments, including those related to privacy\. 

The AWS Panorama Appliance Developer Kit uses unencrypted RTSP camera streams\. For details on network activity and ports, see [AWS Panorama Appliance network activity](security-infrastructure.md#security-infrastructure-appliance)\. For details on encryption, see [Data protection in AWS Panorama](security-dataprotection.md)\.

## Network configuration for testing with non\-production data \(most secure\)<a name="security-devkit-testdata"></a>

For testing with non\-production data with the AWS Panorama Appliance Developer Kit, we recommend that you use a local IP camera and physically connect the camera to AWS Panorama Appliance using an Ethernet connection\. Then use a subnet \(isolated from your production environment\) to connect the AWS Panorama Appliance to the AWS Cloud\. 

 If a physical Ethernet connection is not possible, you can instead connect the IP camera to a hub on your subnet \(isolated from your production environment\), and use a subnet to connect the AWS Panorama Appliance Developer Kit to the AWS Cloud\. 

## Network configuration for testing with production data \(less secure\)<a name="security-devkit-proddata"></a>

 If you need to test production data with the AWS Panorama Appliance Developer Kit, you can use a separate Virtual Local Area Network \(VLAN\) and restrict access to the VLAN only to the camera and the AWS Panorama Appliance Developer Kit\. Use a firewall to limit incoming and outgoing traffic only to the AWS Cloud endpoints necessary for operation\. This ensures there is a one\-way communication only from the camera to the AWS Panorama Appliance Developer Kit, and isolates your test environment from any other VMS and any production environment\.