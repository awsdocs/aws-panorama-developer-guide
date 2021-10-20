# Managing applications in AWS Panorama<a name="applications-manage"></a>

Use the AWS Panorama console to manage applications and application versions\. An *application* is a computer vision program that runs on the AWS Panorama Appliance\. *Application versions* are immutable snapshots of an application's configuration\. AWS Panorama saves previous versions of your applications so that you can roll back updates that aren't successful, or run different versions on different appliances\.

To create an application, you need application and a computer vision model that is stored in Amazon SageMaker or Amazon Simple Storage Service \(Amazon S3\)\. The application code is a Python script that uses the AWS Panorama Application SDK to process inputs, run inference, and output video\. If you have not created an application yet, see [Getting started with AWS Panorama](panorama-gettingstarted.md) for a walkthrough\.

**Topics**
+ [Deploy an application](#applications-manage-deploy)
+ [Update or copy an application](#applications-manage-clone)
+ [Delete versions and applications](#applications-manage-delete)

## Deploy an application<a name="applications-manage-deploy"></a>

To deploy an application, use the AWS Panorama console\. During the deployment process, you choose which camera streams to pass to the application code, and configure options provided by the application's developer\.

**To deploy an application**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose **Deploy application**\.

1. Paste the contents of the application manifest, `graph.json`, into the text editor\. Choose **Next**\.

1. Enter a name and descroption\.

1. Choose **Proceed to deploy**\.

1. Choose **Begin deployment**\.

1. If your application [uses a role](permissions-application.md), choose it from the drop\-down menu\. Choose **Next**\.

1. Choose **Select device**, and then choose your appliance\. Choose **Next**\.

1. On the **Select data sources** step, choose **View input\(s\)**, and add your camera stream as a data source\. Choose **Next**\.

1. On the **Configure** step, configure any application\-specific settings defined by the developer\. Choose **Next**\.

1. Choose **Deploy**, and then choose **Done**\.

1. In the list of deployed applications, choose the application to monitor its status\.

The deployment process takes 15\-20 minutes\. The appliance's output can be blank for an extended period while the application starts\. If you encounter an error, see [Troubleshooting](panorama-troubleshooting.md)\.

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