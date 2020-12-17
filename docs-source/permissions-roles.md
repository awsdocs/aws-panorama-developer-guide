# Identity\-based IAM policies for AWS Panorama<a name="permissions-roles"></a>

To grant users in your account access to AWS Panorama, you use identity\-based policies in AWS Identity and Access Management \(IAM\)\. Identity\-based policies can apply directly to IAM users, or to IAM groups and roles that are associated with a user\. You can also grant users in another account permission to assume a role in your account and access your AWS Panorama resources\.

AWS Panorama provides managed policies that grant access to AWS Panorama API actions and, in some cases, access to other services used to develop and manage AWS Panorama resources\. AWS Panorama updates the managed policies as needed, to ensure that your users have access to new features when they're released\.
+ **AWSPanoramaFullAccess** – Grants full access to AWS Panorama\. [View policy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AWSPanoramaFullAccess)

Managed policies grant permission to API actions without restricting the resources that a user can modify\. For finer\-grained control, you can create your own policies that limit the scope of a user's permissions\.

At a minimum, an AWS Panorama user needs permission to use the following services in addition to AWS Panorama:

****
+ **Amazon Simple Storage Service \(Amazon S3\)** – To store model and Lambda function artifacts, and can be used for application output\.
+ **AWS Lambda** – To manage function code, configuration, and versions\.
+ **IAM** – To create a Lambda function, a user needs access to assign a role to the function\. You can [create an execution role with basic permissions](https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html) ahead of time, in which case the user needs only [permission to pass the role](https://docs.aws.amazon.com/lambda/latest/dg/access-control-identity-based.html)\.

**Creating service roles**  
The first time you use [the AWS Panorama console](https://console.aws.amazon.com/panorama/home), you need permission to create [service roles](permissions-services.md) used by the AWS Panorama service, the AWS Panorama console, the AWS Panorama Appliance, AWS IoT Greengrass, and SageMaker\. A service role gives a service permission to manage resources or interact with other services\. Create these roles before granting access to your users\.

To create machine learning models or to monitor application output in the console, additional permissions are required\. To use all features of AWS Panorama, also grant a user permission to use the following services:

****
+ **Amazon SageMaker** – Develop, train, and compile machine learning models optimized for the AWS Panorama Appliance
+ **Amazon CloudWatch** – View metrics output by AWS Panorama, Lambda, and other services
+ **Amazon CloudWatch Logs** – View application logs

For details on the resources and conditions that you can use to limit the scope of a user's permissions in AWS Panorama, see [Actions, resources, and condition keys for AWS Panorama](https://docs.aws.amazon.com/service-authorization/latest/reference/list_awspanorama.html) in the Service Authorization Reference\.