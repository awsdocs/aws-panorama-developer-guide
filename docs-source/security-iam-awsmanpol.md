# AWS managed policies for AWS Panorama<a name="security-iam-awsmanpol"></a>

To add permissions to users, groups, and roles, it is easier to use AWS managed policies than to write policies yourself\. It takes time and expertise to [create IAM customer managed policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_create-console.html) that provide your team with only the permissions they need\. To get started quickly, you can use our AWS managed policies\. These policies cover common use cases and are available in your AWS account\. For more information about AWS managed policies, see [AWS managed policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies) in the *IAM User Guide*\.

AWS services maintain and update AWS managed policies\. You can't change the permissions in AWS managed policies\. Services occasionally add additional permissions to an AWS managed policy to support new features\. This type of update affects all identities \(users, groups, and roles\) where the policy is attached\. Services are most likely to update an AWS managed policy when a new feature is launched or when new operations become available\. Services do not remove permissions from an AWS managed policy, so policy updates won't break your existing permissions\.

Additionally, AWS supports managed policies for job functions that span multiple services\. For example, the `ViewOnlyAccess` AWS managed policy provides read\-only access to many AWS services and resources\. When a service launches a new feature, AWS adds read\-only permissions for new operations and resources\. For a list and descriptions of job function policies, see [AWS managed policies for job functions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html) in the *IAM User Guide*\.

AWS Panorama provides the following managed policies\. For the full contents and change history of each policy, see the linked pages in the IAM console\.

****
+ [AWSPanoramaFullAccess](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AWSPanoramaFullAccess) – Provides full access to AWS Panorama, AWS Panorama access points in Amazon S3, appliance credentials in AWS Secrets Manager, and appliance logs in Amazon CloudWatch\. Includes permission to create a [service\-linked role](permissions-services.md) for AWS Panorama\. 
+ [AWSPanoramaServiceLinkedRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSPanoramaServiceLinkedRolePolicy) – Allows AWS Panorama to manage resources in AWS IoT, AWS Secrets Manager, and AWS Panorama\.
+ [AWSPanoramaApplianceServiceRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSPanoramaApplianceServiceRolePolicy) – Allows an AWS Panorama Appliance to upload logs to CloudWatch, and to get objects from Amazon S3 access points created by AWS Panorama\.

## AWS Panorama updates to AWS managed policies<a name="security-iam-awsmanpol-updates"></a>

The following table describes updates to managed policies for AWS Panorama\.


| Change | Description | Date | 
| --- | --- | --- | 
|  AWSPanoramaFullAccess – Update to an existing policy  |  Added permissions to the user policy to allow users to view log groups in the CloudWatch Logs console\.  |  2022\-01\-13  | 
|  AWSPanoramaFullAccess – Update to an existing policy  |  Added permissions to the user policy to allow users to manage the AWS Panorama [service\-linked role](using-service-linked-roles.md), and to access AWS Panorama resources in other services including IAM, Amazon S3, CloudWatch, and Secrets Manager\.  |  2021\-10\-20  | 
|  AWSPanoramaApplianceServiceRolePolicy – New policy  |  New policy for the AWS Panorama Appliance service role  |  2021\-10\-20  | 
|  AWSPanoramaServiceLinkedRolePolicy – New policy  |  New policy for the AWS Panorama service\-linked role\.  |  2021\-10\-20  | 
|  AWS Panorama started tracking changes  |  AWS Panorama started tracking changes for its AWS managed policies\.  |  2021\-10\-20  | 