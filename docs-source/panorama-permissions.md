# AWS Panorama permissions<a name="panorama-permissions"></a>

You can use AWS Identity and Access Management \(IAM\) to manage access to the AWS Panorama service and resources like appliances and applications\. For users in your account that use AWS Panorama, you manage permissions in a permissions policy that you can apply to IAM users, groups, or roles\. To manage permissions for the AWS Panorama Appliance, you add policies to a role that is specific to the appliance\.

To [manage permissions for users](permissions-user.md) in your account, use the managed policy that AWS Panorama provides, or write your own\. The AWS Panorama console uses multiple services to get information about your restrictive policies\.

An AWS Panorama Appliance also has a role that grants it permission to access AWS services and resources\. If your application accesses services with the AWS SDK, you grant it permission to call them in the appliance's role\. The appliance's role is one of the [service roles](permissions-services.md) that the AWS Panorama service uses to access other services on your behalf\.

You can restrict user permissions by the resource an action affects and, in some cases, by additional conditions\. For example, you can specify a pattern for the Amazon Resource Name \(ARN\) of an application that requires a user to include their user name in the name of applications that they create\. For the resources and conditions that are supported by each action, see [Actions, resources, and condition keys for AWS Panorama](https://docs.aws.amazon.com/service-authorization/latest/reference/list_awspanorama.html) in the Service Authorization Reference\.

For more information, see [What is IAM?](https://docs.aws.amazon.com/IAM/latest/UserGuide/) in the IAM User Guide\.

**Topics**
+ [Identity\-based IAM policies for AWS Panorama](permissions-user.md)
+ [AWS Panorama service roles and cross\-service resources](permissions-services.md)
+ [Granting permissions to an application](permissions-application.md)