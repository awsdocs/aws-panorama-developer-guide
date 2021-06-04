# Deploying the AWS Panorama sample application<a name="gettingstarted-deploy"></a>

After you've [set up your AWS Panorama Appliance Developer Kit](gettingstarted-setup.md) and upgraded its software, deploy a sample application\. In the following sections, you define the application code, import a machine learning model, and deploy an application with the AWS Panorama console\.

The sample application uses a machine learning model to detect people in frames of video from a network camera\. It uses the AWS Panorama Application SDK to load a model, get images, and run the model\. The application then overlays the results on top of the original video and outputs it to a connected display\.

In a retail setting, analyzing foot traffic patterns enables you to predict traffic levels\. By combining the analysis with other data, you can plan for increased staffing needs around holidays and other events, measure the effectiveness of advertisements and sales promotions, or optimize display placement and inventory management\.

**Topics**
+ [Create a bucket for storage](#gettingstarted-deploy-createbucket)
+ [Create a Lambda function](#gettingstarted-deploy-code)
+ [Create the application](#gettingstarted-deploy-create)
+ [Deploy the application](#gettingstarted-deploy-deploy)
+ [Clean up](#gettingstarted-deploy-cleanup)
+ [Next steps](#gettingstarted-deploy-next)

## Create a bucket for storage<a name="gettingstarted-deploy-createbucket"></a>

Create an Amazon S3 bucket for the sample model file\.

**To create a bucket**

1. Open the [Amazon S3 console](https://console.aws.amazon.com/s3/home)\.

1. Choose **Create bucket**\.

1. Follow the instructions to create a bucket with the following settings:
   + **Bucket name** – The name must contain the phrase `aws-panorama`\. For example, `aws-panorama-artifacts-123456789012`\.
   + **Region** – The AWS Region where you use AWS Panorama\.

1. Upload [the model archive](gettingstarted-setup.md#gettingstarted-prerequisites) to the bucket\.

When the upload operation is complete, view the details of the model file and note the **S3 URL** value for later use\.

## Create a Lambda function<a name="gettingstarted-deploy-code"></a>

Use the Lambda console to create the Lambda function that the application uses to run inference against the model\. The code is stored and versioned in Lambda, but it is not invoked in Lambda\. You deploy the code to the AWS Panorama Appliance Developer Kit and it runs continually while the developer kit is on\.

When you create a Lambda function, you give it a role that enables it to upload logs and access services with the AWS SDK\. This role is typically used when the function runs in Lambda, but when you run the application on the developer kit, the developer kit's permissions are used\. You can let the Lambda console create a role or, if you don't have permission to create roles, use a role that an administrator creates for you\.

**To create a Lambda function**

1. Sign in to the AWS Management Console and open the AWS Lambda console at [https://console\.aws\.amazon\.com/lambda/](https://console.aws.amazon.com/lambda/)\.

1. Choose **Create function**\.

1. For **Basic information**, configure the following settings:
   + **Function name** – `aws-panorama-sample-function`\.
   + **Runtime** – **Python 3\.7**\.
   + **Permissions** – To create a new role, use the default setting\. If you have a role that you want to use, choose **Use an existing role**\.

1. Choose **Create function**\.

Lambda creates the function and opens the function details page\. Modify the function code and configure the function's runtime settings\. Then, to create an immutable snapshot of the function's code and configuration, publish a version\.

**To update the function's code and configuration**

1. For **Code source**, choose **Upload from** and then choose **\.zip file**\. 

1. Upload the [sample code deployment package](samples/aws-panorama-sample.zip) and then choose **Save**\.

1. When the operation is complete, in the **Runtime settings** section, choose **Edit**\.

1. Configure the following settings:
   + **Handler** – `lambda_function.main`\. In the sample application, the `lambda_function.py` file exports a method named `main` that serves as the handler\.

1. Choose **Save**\.

1. Above the code editor, choose the **Configuration** tab\.

1. In the **General configuration** section, choose **Edit**\.

1. Configure the following settings:
   + **Timeout** – **2 minutes**\.
   + **Memory** – **2048 MB**\.

1. Choose **Save**\.

1. Choose **Actions**\.

1. Choose **Publish new version**, and then choose **Publish**\.

When you configure an application, you choose a function version\. Using a version ensures that the application continues to work if you make changes to the function's code\. To update the application's code, you publish a new version in Lambda and configure the application to use it\.

## Create the application<a name="gettingstarted-deploy-create"></a>

In this example, the application uses a Lambda function named `aws-panorama-sample-function` to run inference against the aws\-panorama\-sample\-model model on video streams from a camera\. The function displays the result on an HDMI display connected to the developer kit\.

To import the sample model and create an application, use the AWS Panorama console\.

**To create an application**

1. Open the AWS Panorama console [Getting started page](https://console.aws.amazon.com/panorama/home#getting-started)\.

1. Choose **Create application**\.

1. Complete the workflow with the following settings:
   + **Name** – **aws\-panorama\-sample**
   + Model source – **External model**
   + **Model artifact path** – The Amazon S3 URI of the [model archive](gettingstarted-setup.md#gettingstarted-prerequisites)\. For example: **`s3://aws-panorama-artifacts-123456789012/ssd_512_resnet50_v1_voc.tar.gz`**
   + **Model name** – **aws\-panorama\-sample\-model**

     This value is used by the application code\. Enter it exactly as shown\.
   + **Model framework** – **MXNet**
   + **Input name** – **data**
   + **Shape** – **1,3,512,512**
   + **Lambda functions** – aws\-panorama\-sample\-function version 1

The value for **Shape**, `1,3,512,512`, indicates the number of images that the model takes as input \(1\), the number of channels in each image \(3\-\-red, green, and blue\), and the dimensions of the image \(512 x 512\)\. The values and order of the array varies among models\.

## Deploy the application<a name="gettingstarted-deploy-deploy"></a>

Use the AWS Panorama console to deploy the application to your AWS Panorama Appliance Developer Kit\. AWS Panorama uses AWS IoT Greengrass to deploy the application code and model to the developer kit\.

**To deploy the application**

1. Open the AWS Panorama console [Applications page](https://console.aws.amazon.com/panorama/home#applications)\.

1. To open the application page, choose **aws\-panorama\-sample**\.

1. Choose **Deploy**\.

1. Follow the instructions to deploy the application\.

When the deployment is complete, the application starts processing the video stream and displays the output on the connected monitor\.

If the application doesn't start running, check the [application and device logs](monitoring-logging.md) in Amazon CloudWatch Logs\.

## Clean up<a name="gettingstarted-deploy-cleanup"></a>

If you are done working with the sample application, you can use the AWS Panorama console to remove it from the developer kit and delete it\.

**To remove the application from the developer kit**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose the developer kit\.

1. Check the box next to the application's name\.

1. Choose **Delete application**\.

**To delete the application from AWS Panorama**

1. Open the AWS Panorama console [Applications page](https://console.aws.amazon.com/panorama/home#applications)\.

1. Choose an application\.

1. Choose **Delete**\.

The Lambda function and Amazon S3 bucket that you created are not deleted automatically\. You can delete them in the [Lambda console](https://console.aws.amazon.com/lambda/home) and [Amazon S3 console](https://console.aws.amazon.com/s3/home), respectively\.

## Next steps<a name="gettingstarted-deploy-next"></a>

If you encountered errors while deploying or running the sample application, see [Troubleshooting](panorama-troubleshooting.md)\.

To learn more about the sample application's features and implementation, continue to [the next topic](gettingstarted-devkit.md)\.

To learn about the AWS Panorama Appliance Developer Kit, continue to [Using the AWS Panorama Appliance Developer Kit](gettingstarted-devkit.md)\.