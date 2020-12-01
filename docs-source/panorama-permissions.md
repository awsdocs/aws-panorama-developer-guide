# AWS Panorama permissions<a name="panorama-permissions"></a>

AWS Panorama uses other AWS services to access required AWS resources on your behalf\. The dependent services include the following:
+ AWS Identity and Access Management for managing access permissions\.
+ AWS IoT and AWS IoT Greengrass for managing the AWS Panorama Appliance in the cloud\.
+ AWS Lambda for running inference against trained models and process application data\.
+ Amazon S3 for storing model artifacts and other application data\.
+ SageMaker for importing trained machine learning models and optimizing models during deployment\.
+ Amazon CloudWatch Logs for logging application events and metrics\.

To enable AWS Panorama to access AWS services and resources, you create service roles the first time that you use the AWS Panorama console\.

For more information on the IAM roles and policies, see [AWS Identity and Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)\.

**Topics**
+ [Identity\-based IAM policies for AWS Panorama](permissions-roles.md)
+ [AWS Panorama service roles and cross\-service resources](permissions-services.md)