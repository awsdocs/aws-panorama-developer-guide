# Using service\-linked roles for AWS Panorama<a name="using-service-linked-roles"></a>

AWS Panorama uses AWS Identity and Access Management \(IAM\) [service\-linked roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html#iam-term-service-linked-role)\. A service\-linked role is a unique type of IAM role that is linked directly to AWS Panorama\. Service\-linked roles are predefined by AWS Panorama and include all the permissions that the service requires to call other AWS services on your behalf\. 

A service\-linked role makes setting up AWS Panorama easier because you don’t have to manually add the necessary permissions\. AWS Panorama defines the permissions of its service\-linked roles, and unless defined otherwise, only AWS Panorama can assume its roles\. The defined permissions include the trust policy and the permissions policy, and that permissions policy cannot be attached to any other IAM entity\.

You can delete a service\-linked role only after first deleting their related resources\. This protects your AWS Panorama resources because you can't inadvertently remove permission to access the resources\.

For information about other services that support service\-linked roles, see [AWS services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html) and look for the services that have **Yes** in the **Service\-linked role** column\. Choose a **Yes** with a link to view the service\-linked role documentation for that service\.

**Topics**
+ [Service\-linked role permissions for AWS Panorama](#slr-permissions)
+ [Creating a service\-linked role for AWS Panorama](#create-slr)
+ [Editing a service\-linked role for AWS Panorama](#edit-slr)
+ [Deleting a service\-linked role for AWS Panorama](#delete-slr)
+ [Supported Regions for AWS Panorama service\-linked roles](#slr-regions)

## Service\-linked role permissions for AWS Panorama<a name="slr-permissions"></a>

AWS Panorama uses the service\-linked role named **AWSServiceRoleForAWSPanorama** – Allows AWS Panorama to manage resources in AWS IoT, AWS Secrets Manager, and AWS Panorama\.\.

The AWSServiceRoleForAWSPanorama service\-linked role trusts the following services to assume the role:
+ `panorama.amazonaws.com`

The role permissions policy allows AWS Panorama to complete the following actions:
+ Monitor AWS Panorama resources
+ Manage AWS IoT resources for the AWS Panorama Appliance
+ Access AWS Secrets Manager secrets to get camera credentials

For a full list of permissions, [view the AWSPanoramaServiceLinkedRolePolicy policy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSPanoramaServiceLinkedRolePolicy) in the IAM console\.

You must configure permissions to allow an IAM entity \(such as a user, group, or role\) to create, edit, or delete a service\-linked role\. For more information, see [Service\-linked role permissions](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html#service-linked-role-permissions) in the *IAM User Guide*\.

## Creating a service\-linked role for AWS Panorama<a name="create-slr"></a>

You don't need to manually create a service\-linked role\. When you register an appliance in the AWS Management Console, the AWS CLI, or the AWS API, AWS Panorama creates the service\-linked role for you\. 

If you delete this service\-linked role, and then need to create it again, you can use the same process to recreate the role in your account\. When you register an appliance, AWS Panorama creates the service\-linked role for you again\. 

## Editing a service\-linked role for AWS Panorama<a name="edit-slr"></a>

AWS Panorama does not allow you to edit the AWSServiceRoleForAWSPanorama service\-linked role\. After you create a service\-linked role, you cannot change the name of the role because various entities might reference the role\. However, you can edit the description of the role using IAM\. For more information, see [Editing a service\-linked role](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html#edit-service-linked-role) in the *IAM User Guide*\.

## Deleting a service\-linked role for AWS Panorama<a name="delete-slr"></a>

If you no longer need to use a feature or service that requires a service\-linked role, we recommend that you delete that role\. That way you don’t have an unused entity that is not actively monitored or maintained\. However, you must clean up the resources for your service\-linked role before you can manually delete it\.

To delete the AWS Panorama resources used by the AWSServiceRoleForAWSPanorama, use the procedures in the following sections of this guide\.

****
+ [Delete versions and applications](applications-manage.md#applications-manage-delete)
+ [Deregister an appliance](appliance-manage.md#appliance-manage-delete)

**Note**  
If the AWS Panorama service is using the role when you try to delete the resources, then the deletion might fail\. If that happens, wait for a few minutes and try the operation again\.

To delete the AWSServiceRoleForAWSPanorama service\-linked role, use the IAM console, the AWS CLI, or the AWS API\. For more information, see [Deleting a service\-linked role](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html#delete-service-linked-role) in the *IAM User Guide*\.

## Supported Regions for AWS Panorama service\-linked roles<a name="slr-regions"></a>

AWS Panorama supports using service\-linked roles in all of the regions where the service is available\. For more information, see [AWS Regions and endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html)\.