# AWS Panorama service roles and cross\-service resources<a name="permissions-services"></a>

AWS Panorama uses other AWS services to manage the AWS Panorama Appliance, store data, and import application resources\. These services also call other services using permissions managed with AWS Identity and Access Management \(IAM\) service roles\. A service role gives a service permission to manage resources or interact with other services\. When you sign in to the AWS Panorama console for the first time, you create the following service roles:

****
+ **AWSPanoramaServiceRole** – Allows AWS Panorama to manage resources in Amazon Simple Storage Service \(Amazon S3\), AWS IoT, AWS IoT Greengrass, AWS Lambda, Amazon SageMaker, and Amazon CloudWatch, and to pass service roles to AWS IoT, AWS IoT Greengrass, and SageMaker

  Managed policy: [AWSPanoramaServiceRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSPanoramaServiceRolePolicy)
+ **AWSPanoramaApplianceRole** – Allows AWS IoT software on an AWS Panorama Appliance to upload logs to CloudWatch

  Managed policy: [AWSPanoramaApplianceRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSPanoramaApplianceRolePolicy)
+ **AWSPanoramaSageMakerRole** – Allows SageMaker to manage objects in buckets created for use with AWS Panorama

  Managed policy: [AWSPanoramaSageMakerRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSPanoramaSageMakerRolePolicy)
+ **AWSPanoramaGreengrassGroupRole** – Allows a Lambda function on an AWS Panorama Appliance to manage resources in AWS Panorama, upload logs and metrics to CloudWatch, and manage objects in buckets created for use with AWS Panorama

  Managed policy: [AWSPanoramaGreengrassGroupRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSPanoramaGreengrassGroupRolePolicy)
+ **AWSPanoramaGreengrassRole** – Grants AWS IoT Greengrass permission to access resources in Lambda, SageMaker, Amazon S3, and AWS IoT

  Managed policy: [AWSGreengrassResourceAccessRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSGreengrassResourceAccessRolePolicy)

To view the permissions attached to each role, use the [IAM console](https://console.aws.amazon.com/iam)\. Wherever possible, the role's permissions are restricted to resources that match a naming pattern that AWS Panorama uses\. For example, **AWSPanoramaServiceRole** grants only permission for the service to access Amazon S3 buckets that include the phrase `aws-panorama`\.

AWS Panorama creates or accesses resources in the following services: 

****
+ [AWS IoT](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_awsiot.html) – Things, policies, certificates, and jobs for the AWS Panorama Appliance
+ [Amazon S3](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazons3.html) – Buckets and objects for model storage and application output
+ [AWS IoT Greengrass](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_awsiotgreengrass.html) – A [Greengrass resource](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_awsiotgreengrass.html#awsiotgreengrass-resources-for-iam-policies) that manages the AWS Panorama Appliance
+ [Lambda](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_awslambda.html) – Lambda functions that perform inference or process data in an application
+ [SageMaker](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazonsagemaker.html) – A [training job](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazonsagemaker.html#amazonsagemaker-resources-for-iam-policies) that trains a model for use with an application
+ [CloudWatch Logs](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazoncloudwatchlogs.html) – Log groups and log streams for application logs
+ [IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_identityandaccessmanagement.html) – Service roles and Lambda function runtime roles

For information about Amazon Resource Name \(ARN\) format or permission scopes for each service, see the topics in the *IAM User Guide* that are linked to in this list\.