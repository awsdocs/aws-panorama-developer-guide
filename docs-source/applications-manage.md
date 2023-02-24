# Managing applications in the AWS Panorama console<a name="applications-manage"></a>

Use the AWS Panorama console to manage deployed applications\.

**Topics**
+ [Update or copy an application](#applications-manage-clone)
+ [Delete versions and applications](#applications-manage-delete)

## Update or copy an application<a name="applications-manage-clone"></a>

To update an application, use the **Replace** option\. When you replace an application, you can update its code or models\.

**To update an application**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose an application\.

1. Choose **Replace**\.

1. Follow the instructions to create a new version or application\.

There is also a **Clone** option that acts similar to **Replace**, but doesn't remove the old version of the application\. You can use this option to test changes to an application without stopping the running version, or to redeploy a version that you've already deleted\.

## Delete versions and applications<a name="applications-manage-delete"></a>

To clean up unused application versions, delete them from your appliances\.

**To delete an application**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose an application\.

1. Choose **Delete from device**\.