# Data protection in AWS Panorama<a name="security-dataprotection"></a>

The AWS [shared responsibility model](http://aws.amazon.com/compliance/shared-responsibility-model/) applies to data protection in AWS Panorama\. As described in this model, AWS is responsible for protecting the global infrastructure that runs all of the AWS Cloud\. You are responsible for maintaining control over your content that is hosted on this infrastructure\. This content includes the security configuration and management tasks for the AWS services that you use\. For more information about data privacy, see the [Data Privacy FAQ](http://aws.amazon.com/compliance/data-privacy-faq)\. For information about data protection in Europe, see the [AWS Shared Responsibility Model and GDPR](http://aws.amazon.com/blogs/security/the-aws-shared-responsibility-model-and-gdpr/) blog post on the *AWS Security Blog*\.

For data protection purposes, we recommend that you protect AWS account credentials and set up individual user accounts with AWS Identity and Access Management \(IAM\)\. That way each user is given only the permissions necessary to fulfill their job duties\. We also recommend that you secure your data in the following ways:
+ Use multi\-factor authentication \(MFA\) with each account\.
+ Use SSL/TLS to communicate with AWS resources\. We recommend TLS 1\.2 or later\.
+ Set up API and user activity logging with AWS CloudTrail\.
+ Use AWS encryption solutions, along with all default security controls within AWS services\.
+ Use advanced managed security services such as Amazon Macie, which assists in discovering and securing personal data that is stored in Amazon S3\.
+ If you require FIPS 140\-2 validated cryptographic modules when accessing AWS through a command line interface or an API, use a FIPS endpoint\. For more information about the available FIPS endpoints, see [Federal Information Processing Standard \(FIPS\) 140\-2](http://aws.amazon.com/compliance/fips/)\.

We strongly recommend that you never put confidential or sensitive information, such as your customers' email addresses, into tags or free\-form fields such as a **Name** field\. This includes when you work with AWS Panorama or other AWS services using the console, API, AWS CLI, or AWS SDKs\. Any data that you enter into tags or free\-form fields used for names may be used for billing or diagnostic logs\. If you provide a URL to an external server, we strongly recommend that you do not include credentials information in the URL to validate your request to that server\.

**Topics**
+ [Encryption in transit](#security-privacy-intransit)
+ [AWS Panorama Appliance](#security-privacy-atrest)
+ [Applications](#security-privacy-applications)
+ [Other services](#security-privacy-services)

## Encryption in transit<a name="security-privacy-intransit"></a>

AWS Panorama API endpoints support secure connections only over HTTPS\. When you manage AWS Panorama resources with the AWS Management Console, AWS SDK, or the AWS Panorama API, all communication is encrypted with Transport Layer Security \(TLS\)\. Communication between the AWS Panorama Appliance and AWS is also encrypted with TLS\. Communication between the AWS Panorama Appliance and cameras over RTSP is not encrypted\.

For a complete list of API endpoints, see [AWS Regions and endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html) in the *AWS General Reference*\.

## AWS Panorama Appliance<a name="security-privacy-atrest"></a>

The AWS Panorama Appliance has physical ports for Ethernet, HDMI video, and USB storage\. The SD card slot, Wi\-Fi, and Bluetooth are not usable\. The USB port is only used during provisioning to transfer a configuration archive to the appliance\.

The contents of the configuration archive, which includes the appliance's provisioning certificate and network configuration, are not encrypted\. AWS Panorama does not store these files; they can only be retrieved when you register an appliance\. After you transfer the configuration archive to an appliance, delete it from your computer and USB storage device\.

The entire file system of the appliance is encrypted\. Additionally, the appliance applies several system\-level protections, including rollback protection for required software updates, signed kernel and bootloader, and software integrity verification\.

When you stop using the appliance, perform a [full reset](appliance-buttons.md#appliance-buttons-reset) to delete your application data and reset the appliance software\.

## Applications<a name="security-privacy-applications"></a>

You control the code that you deploy to your appliance\. Validate all application code for security issues before deploying it, regardless of its source\. If you use 3rd party libraries in your application, carefully consider the licensing and support policies for those libraries\.

Application CPU, memory, and disk usage are not constrained by the appliance software\. An application using too many resources can negatively impact other applications and the device’s operation\. Test applications separately before combining or deploying to production environments\.

Application assets \(codes and models\) are not isolated from access within your account, appliance, or build environment\. The container images and model archives generated by the AWS Panorama Application CLI are not encrypted\. Use separate accounts for production workloads and only allow access on an as\-needed basis\.

## Other services<a name="security-privacy-services"></a>



To store your models and application containers securely in Amazon S3, AWS Panorama uses server\-side encryption with a key that Amazon S3 manages\. For more information, see [Protecting data using encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingEncryption.html) in the Amazon Simple Storage Service User Guide\.

Camera stream credentials are encrypted at rest in AWS Secrets Manager\. The appliance's IAM role grants it permission to retrieve the secret in order to access the stream's username and password\.

The AWS Panorama Appliance sends log data to Amazon CloudWatch Logs\. CloudWatch Logs encrypts this data by default, and can be configured to use a customer managed key\. For more information, see [Encrypt log data in CloudWatch Logs using AWS KMS](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html) in the Amazon CloudWatch Logs User Guide\.