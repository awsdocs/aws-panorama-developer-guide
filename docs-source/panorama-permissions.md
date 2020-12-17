# AWS Panorama permissions<a name="panorama-permissions"></a>

You can use AWS Identity and Access Management \(IAM\) to manage access to the AWS Panorama service and resources like appliances and applications\. For users in your account that use AWS Panorama, you manage permissions in a permissions policy that you can apply to IAM users, groups, or roles\. To manage permissions for the AWS Panorama Appliance, you add policies to a role that is specific to the appliance\.

To [manage permissions for users](permissions-roles.md) in your account, use the managed policy that AWS Panorama provides, or write your own\. The AWS Panorama console uses multiple services to get information about your restrictive policies\.

An AWS Panorama Appliance also has a role that grants it permission to access AWS services and resources\. If your application accesses services with the AWS SDK, you grant it permission to call them in the appliance's role\. The appliance's role is one of several [service roles](permissions-services.md) that the AWS Panorama service uses to access other services on your behalf\.

For more information, see [What is IAM?](https://docs.aws.amazon.com/IAM/latest/UserGuide/) in the IAM User Guide\.

**Topics**
+ [Identity\-based IAM policies for AWS Panorama](permissions-roles.md)
+ [AWS Panorama service roles and cross\-service resources](permissions-services.md)