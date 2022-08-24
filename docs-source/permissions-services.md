# AWS Panorama service roles and cross\-service resources<a name="permissions-services"></a>

AWS Panorama uses other AWS services to manage the AWS Panorama Appliance, store data, and import application resources\. A service role gives a service permission to manage resources or interact with other services\. When you sign in to the AWS Panorama console for the first time, you create the following service roles:

****
+ **AWSServiceRoleForAWSPanorama** – Allows AWS Panorama to manage resources in AWS IoT, AWS Secrets Manager, and AWS Panorama\.

  Managed policy: [AWSPanoramaServiceLinkedRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSPanoramaServiceLinkedRolePolicy)
+ **AWSPanoramaApplianceServiceRole** – Allows an AWS Panorama Appliance to upload logs to CloudWatch, and to get objects from Amazon S3 access points created by AWS Panorama\.

  Managed policy: [AWSPanoramaApplianceServiceRolePolicy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/aws-service-role/AWSPanoramaApplianceServiceRolePolicy)

To view the permissions attached to each role, use the [IAM console](https://console.aws.amazon.com/iam)\. Wherever possible, the role's permissions are restricted to resources that match a naming pattern that AWS Panorama uses\. For example, `AWSServiceRoleForAWSPanorama` grants only permission for the service to access AWS IoT resources that have `panorama` in their name\.

**Topics**
+ [Securing the appliance role](#permissions-services-appliance)
+ [Use of other services](#permissions-services-otherservices)

## Securing the appliance role<a name="permissions-services-appliance"></a>

The AWS Panorama Appliance uses the `AWSPanoramaApplianceServiceRole` role to access resources in your account\. The appliance has permission to upload logs to CloudWatch Logs, read camera stream credentials from AWS Secrets Manager, and to access application artifacts in Amazon Simple Storage Service \(Amazon S3\) access points that AWS Panorama creates\.

**Note**  
Applications don't use the appliance's permissions\. To give your application permission to use AWS services, create an [application role](permissions-application.md)\.

AWS Panorama uses the same service role with all appliances in your account, and does not use roles across accounts\. For an added layer of security, you can modify the appliance role's trust policy to enforce this explicitly, which is a best practice when you use roles to grant a service permission to access resources in your account\.

**To update the appliance role trust policy**

1. Open the appliance role in the IAM console: [AWSPanoramaApplianceServiceRole](https://console.aws.amazon.com/iam/home#/roles/AWSPanoramaApplianceServiceRole?section=trust)

1. Choose **Edit trust relationship**\.

1. Update the policy contents and then choose **Update trust policy**\.

The following trust policy includes a condition that ensures that when AWS Panorama assumes the appliance role, it is doing so for an appliance in your account\. The `aws:SourceAccount` condition compares the account ID specified by AWS Panorama to the one that you include in the policy\.

**Example trust policy – Specific account**  

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "panorama.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "123456789012"
        }
      }
    }
  ]
}
```

If you want to restrict AWS Panorama further, and allow it to only assume the role with a specific device, you can specify the device by ARN\. The `aws:SourceArn` condition compares the ARN of the appliance specified by AWS Panorama to the one that you include in the policy\.

**Example trust policy – Single appliance**  

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "panorama.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:panorama:us-east-1:123456789012:device/device-lk7exmplpvcr3heqwjmesw76ky"
        },
        "StringEquals": {
          "aws:SourceAccount": "123456789012"
        }
      }
    }
  ]
}
```

If you reset and reprovision the appliance, you must remove the source ARN condition temporarily and then add it again with the new device ID\.

For more information on these conditions, and security best practices when services use roles to access resources in your account, see [The confused deputy problem](https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html) in the IAM User Guide\.

## Use of other services<a name="permissions-services-otherservices"></a>

AWS Panorama creates or accesses resources in the following services: 

****
+ [AWS IoT](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_awsiot.html) – Things, policies, certificates, and jobs for the AWS Panorama Appliance
+ [Amazon S3](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazons3.html) – Access points for staging application models, code, and configurations\.
+ [Secrets Manager](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_awssecretsmanager.html) – Short\-term credentials for the AWS Panorama Appliance\.

For information about Amazon Resource Name \(ARN\) format or permission scopes for each service, see the topics in the *IAM User Guide* that are linked to in this list\.