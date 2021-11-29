# Infrastructure security in AWS Panorama<a name="security-infrastructure"></a>

As a managed service, AWS Panorama is protected by the AWS global network security procedures that are described in the [Amazon Web Services: Overview of security processes](https://d0.awsstatic.com/whitepapers/Security/AWS_Security_Whitepaper.pdf) whitepaper\.

You use AWS published API calls to access AWS Panorama through the network\. Clients must support Transport Layer Security \(TLS\) 1\.2 or later\. Clients must also support cipher suites with perfect forward secrecy \(PFS\) such as Ephemeral Diffie\-Hellman \(DHE\) or Elliptic Curve Ephemeral Diffie\-Hellman \(ECDHE\)\. Most modern systems such as Java 7 and later support these modes\.

Additionally, requests must be signed by using an access key ID and a secret access key that is associated with an IAM principal\. Or you can use [AWS Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html) \(AWS STS\) to generate temporary security credentials to sign requests\.

The AWS Panorama Appliance needs internet access to communicate with AWS services\. It also needs access to your internal network of cameras\. It is important to consider your network configuration carefully and only provide each device the access that it needs\. Be careful if your configuration allows the AWS Panorama Appliance to act as a bridge to a sensitive IP camera network\. 

You are responsible for the following:
+  The physical and logical network security of the AWS Panorama Appliance\. 
+  Securely operating the network\-attached cameras when you use the AWS Panorama Appliance\. 
+  Keeping the AWS Panorama Appliance and camera software updated\. 
+  Complying with any applicable laws or regulations associated with the content of the videos and images you gather from your production environments, including those related to privacy\. 

The AWS Panorama Appliance uses unencrypted RTSP camera streams\. For more information on connecting the AWS Panorama Appliance to your network, see [Connecting the AWS Panorama Appliance to your network](appliance-network.md)\. For details on encryption, see [Data protection in AWS Panorama](security-dataprotection.md)\.