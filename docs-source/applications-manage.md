# Managing applications and application versions in AWS Panorama<a name="applications-manage"></a>

Use the AWS Panorama console to manage applications and application versions\. An *application* is a computer vision program that runs on the AWS Panorama Appliance\. *Application versions* are immutable snapshots of an application's configuration\. AWS Panorama saves previous versions of your applications so that you can roll back updates that aren't successful, or run different versions on different appliances\.

To create an application, you need an AWS Lambda function and a computer vision model that is stored in Amazon SageMaker or Amazon Simple Storage Service \(Amazon S3\)\. The application code is a Python script that uses the AWS Panorama Application SDK to process inputs, run inference, and output video\. If you have not created an application yet, see [Getting started with AWS Panorama](panorama-gettingstarted.md) for a walkthrough\.

**Topics**
+ [Deploy an application](#applications-manage-deploy)
+ [Update or copy an application](#applications-manage-clone)
+ [Delete versions and applications](#applications-manage-delete)

## Deploy an application<a name="applications-manage-deploy"></a>

To deploy an application, use the AWS Panorama console\. During the deployment process, you choose which camera streams to pass to the application code, and whether to send the output to a display\.

**To deploy an application**

1. Open the AWS Panorama console [Applications page](https://console.aws.amazon.com/panorama/home#applications)\.

1. Choose an application\.

1. \(Optional\) To deploy a previous version of the application, for **Version**, choose the version you want to deploy\.

1. Choose **Deploy**\.

1. Follow the instructions to deploy the application version\.

The deployment process takes a few minutes\. The appliance's output can be blank for an extended period while the application starts\. If you encounter an error, see [Troubleshooting](panorama-troubleshooting.md)\.

## Update or copy an application<a name="applications-manage-clone"></a>

To update an application or create a copy of it, use the **Clone** option\. AWS Panorama saves all versions of applications until you delete them\. When you clone an application, you can update its function or models\.

**To clone an application**

1. Open the AWS Panorama console [Applications page](https://console.aws.amazon.com/panorama/home#applications)\.

1. Choose an application\.

1. Choose **Clone**\.

1. Follow the instructions to create a new version or application\.

## Delete versions and applications<a name="applications-manage-delete"></a>

To clean up unused application versions, delete them\. When you delete an application version, AWS Panorama removes it from connected appliances\. If an appliance is offline when its application is deleted, you can [remove it from the appliance](appliance-applications.md) after it reconnects\.

**To delete an application version**

1. Open the AWS Panorama console [Applications page](https://console.aws.amazon.com/panorama/home#applications)\.

1. Choose an application\.

1. For **Version**, choose a version\.

1. Choose **Delete**\.

An application must have at least one version\. To remove all versions, delete the application\.

**To delete an application**

1. Open the AWS Panorama console [Applications page](https://console.aws.amazon.com/panorama/home#applications)\.

1. Choose an application\.

1. Choose **Delete application**\.