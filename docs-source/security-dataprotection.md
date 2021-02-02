# Data protection in AWS Panorama<a name="security-dataprotection"></a>

The AWS [shared responsibility model](http://aws.amazon.com/compliance/shared-responsibility-model/) applies to data protection in AWS Panorama\. As described in this model, AWS is responsible for protecting the global infrastructure that runs all of the AWS Cloud\. You are responsible for maintaining control over your content that is hosted on this infrastructure\. This content includes the security configuration and management tasks for the AWS services that you use\. For more information about data privacy, see the [Data Privacy FAQ](http://aws.amazon.com/compliance/data-privacy-faq)\. For information about data protection in Europe, see the [AWS Shared Responsibility Model and GDPR](http://aws.amazon.com/blogs/security/the-aws-shared-responsibility-model-and-gdpr/) blog post on the *AWS Security Blog*\.

For data protection purposes, we recommend that you protect AWS account credentials and set up individual user accounts with AWS Identity and Access Management \(IAM\)\. That way each user is given only the permissions necessary to fulfill their job duties\. We also recommend that you secure your data in the following ways:
+ Use multi\-factor authentication \(MFA\) with each account\.
+ Use SSL/TLS to communicate with AWS resources\. We recommend TLS 1\.2 or later\.
+ Set up API and user activity logging with AWS CloudTrail\.
+ Use AWS encryption solutions, along with all default security controls within AWS services\.
+ Use advanced managed security services such as Amazon Macie, which assists in discovering and securing personal data that is stored in Amazon S3\.
+ If you require FIPS 140\-2 validated cryptographic modules when accessing AWS through a command line interface or an API, use a FIPS endpoint\. For more information about the available FIPS endpoints, see [Federal Information Processing Standard \(FIPS\) 140\-2](http://aws.amazon.com/compliance/fips/)\.

We strongly recommend that you never put sensitive identifying information, such as your customers' account numbers, into free\-form fields such as a **Name** field\. This includes when you work with AWS Panorama or other AWS services using the console, API, AWS CLI, or AWS SDKs\. Any data that you enter into AWS Panorama or other services might get picked up for inclusion in diagnostic logs\. When you provide a URL to an external server, don't include credentials information in the URL to validate your request to that server\.

**Topics**
+ [Encryption in transit](#security-privacy-intransit)
+ [Encryption at rest](#security-privacy-atrest)

## Encryption in transit<a name="security-privacy-intransit"></a>

AWS Panorama API endpoints support secure connections only over HTTPS\. When you manage AWS Panorama resources with the AWS Management Console, AWS SDK, or the AWS Panorama API, all communication is encrypted with Transport Layer Security \(TLS\)\. Communication between the AWS Panorama Appliance and AWS is also encrypted with TLS\. Communication between the AWS Panorama Appliance and cameras over RTSP is not encrypted\.

For a complete list of API endpoints, see [AWS Regions and endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html) in the *AWS General Reference*\.

## Encryption at rest<a name="security-privacy-atrest"></a>

The AWS Panorama service does not copy or store data such as machine learning models and application code\. These artifacts are stored in other services and AWS Panorama uses AWS IoT Greengrass to deploy them to the AWS Panorama Appliance Developer Kit\. Configuration files, models, and code are not encrypted at rest on the AWS Panorama Appliance Developer Kit\.

The contents of the configuration archive, which includes the appliance's private key and network configuration, are not encrypted\. The network configuration file contains the Wi\-Fi password and SSH credentials in plain text\. AWS Panorama does not store these files; they can only be retrieved when you register an appliance\. After you transfer the configuration archive to an appliance, delete it from your computer and USB storage device\.

Other settings, such as camera stream credentials \(username and password\) are encrypted at rest in AWS\. Settings are decrypted prior to transport and sent to the appliance over TLS\.

To store your models securely in Amazon S3, you can use server\-side encryption with a key that Amazon S3 manages, or one that you provide\. For more information, see [Protecting data using encryption](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingEncryption.html) in the Amazon Simple Storage Service Developer Guide\.

When you author application code in AWS Lambda, Lambda encrypts the function code by default\. For more information, see [Data protection in AWS Lambda ](https://docs.aws.amazon.com/lambda/latest/dg/security-dataprotection.html) in the AWS Lambda Developer Guide\.

The AWS Panorama Appliance sends log data to Amazon CloudWatch Logs\. CloudWatch Logs encrypts this data by default, and can be configured to use a customer managed key\. For more information, see [Encrypt log data in CloudWatch Logs using AWS KMS](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html) in the Amazon CloudWatch Logs User Guide\.