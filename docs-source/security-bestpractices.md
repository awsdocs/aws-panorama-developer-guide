# AWS Panorama Appliance security best practices<a name="security-bestpractices"></a>

Keep in mind the following best practices when using the AWS Panorama appliance\.

****
+ **Physically secure the appliance** – Install the appliance in an enclosed server rack or secure room\. Limit physical access to the device to authorized personnel\.
+ **Secure the appliance's network connection** – Connect the appliance to a router that limits access to internal and external resources\. The appliance needs to connect to cameras, which can be on a secure internal network\. It also needs to connect to AWS\. Use the second Ethernet port only for physical redundancy, and configure the router to allow only required traffic\.

  Use one of the recommended network configurations to plan your network layout\. For more information, see [Connecting the AWS Panorama Appliance to your network](appliance-network.md)\.
+ **Format the USB drive** – After provisioning an appliance, remove the USB drive and format it\. The appliance does not use the USB drive after it registers with the AWS Panorama service\. Format the drive to remove temporary credentials, configuration files, and provisioning logs\.
+ **Keep the appliance up to date** – Apply appliance software updates in a timely manner\. When you view an appliance in the AWS Panorama console, the console notifies you if a software update is available\. For more information, see [Managing an AWS Panorama Appliance](appliance-manage.md)\.

  With the [DescribeDevice](https://docs.aws.amazon.com/panorama/latest/api/API_DescribeDevice.html) API operation, you can automate checking for updates by comparing the `LatestSoftware` and `CurrentSoftware` fields\. When the latest software version differs from the current version, apply the update with the console or by using the [CreateJobForDevices](https://docs.aws.amazon.com/panorama/latest/api/API_CreateJobForDevices.html) operation\.
+ **If you stop using an appliance, reset it** – Before you move the appliance out of your secure data center, fully reset it\. With the appliance powered down and plugged in, press both the power and reset button simultaneously for 5 seconds\. This deletes account credentials, applications, and logs from the appliance\.

  For more information, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.
+ **Limit access to AWS Panorama and other AWS services** – The [AWSPanoramaFullAccess](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/) provides access to all AWS Panorama API operations and, as necessary, access to other services\. Where possible, the policy limits access to resources based on naming conventions\. For example, it provides access to AWS Secrets Manager secrets that have names starting with `panorama`\. For users that need read\-only access, or access to a more specific set of resources, use the managed policy as a starting point for your least\-privilege policies\.

  For more information, see [Identity\-based IAM policies for AWS Panorama](permissions-user.md)\.