# Deploying the AWS Panorama sample application<a name="gettingstarted-deploy"></a>

After you've [set up your AWS Panorama Appliance or compatible device](gettingstarted-setup.md) and upgraded its software, deploy a sample application\. In the following sections, you import a sample application with the AWS Panorama Application CLI and deploy it with the AWS Panorama console\.

The sample application uses a machine learning model to classify objects in frames of video from a network camera\. It uses the AWS Panorama Application SDK to load a model, get images, and run the model\. The application then overlays the results on top of the original video and outputs it to a connected display\.

In a retail setting, analyzing foot traffic patterns enables you to predict traffic levels\. By combining the analysis with other data, you can plan for increased staffing needs around holidays and other events, measure the effectiveness of advertisements and sales promotions, or optimize display placement and inventory management\.

**Topics**
+ [Prerequisites](#gettingstarted-deploy-prerequisites)
+ [Import the sample application](#gettingstarted-deploy-import)
+ [Deploy the application](#gettingstarted-deploy-deploy)
+ [View the output](#gettingstarted-deploy-view)
+ [Enable the SDK for Python](#gettingstarted-deploy-redeploy)
+ [Clean up](#gettingstarted-deploy-cleanup)
+ [Next steps](#gettingstarted-deploy-next)

## Prerequisites<a name="gettingstarted-deploy-prerequisites"></a>

To follow the procedures in this tutorial, you need a command line terminal or shell to run commands\. In the code listings, commands are preceded by a prompt symbol \($\) and the name of the current directory, when appropriate\.

```
~/panorama-project$ this is a command
this is output
```

For long commands, we use an escape character \(`\`\) to split a command over multiple lines\.

On Linux and macOS, use your preferred shell and package manager\. On Windows 10, you can [install the Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to get a Windows\-integrated version of Ubuntu and Bash\. For help setting up a development environment in Windows, see [Setting up a development environment in Windows](applications-devenvwindows.md)\.

You use Python to develop AWS Panorama applications and install tools with pip, Python's package manager\. If you don't already have Python, [install the latest version](https://www.python.org/downloads/)\. If you have Python 3 but not pip, install pip with your operating system's package manager, or install a new version of Python, which comes with pip\.

In this tutorial, you use Docker to build the container that runs your application code\. Install Docker from the Docker website: [Get Docker](https://docs.docker.com/get-docker/)

This tutorial uses the AWS Panorama Application CLI to import the sample application, build packages, and upload artifacts\. The AWS Panorama Application CLI uses the AWS Command Line Interface \(AWS CLI\) to call service API operations\. If you already have the AWS CLI, upgrade it to the latest version\. To install the AWS Panorama Application CLI and AWS CLI, use `pip`\.

```
$ pip3 install --upgrade awscli panoramacli
```

Download the sample application, and extract it into your workspace\.

****
+ **Sample application** – [aws\-panorama\-sample\.zip](https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v1.0-ga/aws-panorama-sample.zip)

## Import the sample application<a name="gettingstarted-deploy-import"></a>

To import the sample application for use in your account, use the AWS Panorama Application CLI\. The application's folders and manifest contain references to a placeholder account number\. To update these with your account number, run the `panorama-cli import-application` command\.

```
aws-panorama-sample$ panorama-cli import-application
```

The `SAMPLE_CODE` package, in the `packages` directory, contains the application's code and configuration, including a Dockerfile that uses the application base image, `panorama-application`\. To build the application container that runs on the appliance, use the `panorama-cli build-container` command\.

```
aws-panorama-sample$ ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
aws-panorama-sample$ panorama-cli build-container --container-asset-name code_asset --package-path packages/${ACCOUNT_ID}-SAMPLE_CODE-1.0
```

The final step with the AWS Panorama Application CLI is to register the application's code and model nodes, and upload assets to an Amazon S3 access point provided by the service\. The assets include the code's container image, the model, and a descriptor file for each\. To register the nodes and upload assets, run the `panorama-cli package-application` command\.

```
aws-panorama-sample$ panorama-cli package-application
Uploading package model
Registered model with patch version bc9c58bd6f83743f26aa347dc86bfc3dd2451b18f964a6de2cc4570cb6f891f9
Uploading package code
Registered code with patch version 11fd7001cb31ea63df6aaed297d600a5ecf641a987044a0c273c78ceb3d5d806
```

## Deploy the application<a name="gettingstarted-deploy-deploy"></a>

Use the AWS Panorama console to deploy the application to your appliance\.

**To deploy the application**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose **Deploy application**\.

1. Paste the contents of the application manifest, `graphs/aws-panorama-sample/graph.json`, into the text editor\. Choose **Next**\.

1. For **Application name**, enter `aws-panorama-sample`\.

1. Choose **Proceed to deploy**\.

1. Choose **Begin deployment**\.

1. Choose **Next** without selecting a role\.

1. Choose **Select device**, and then choose your appliance\. Choose **Next**\.

1. On the **Select data sources** step, choose **View input\(s\)**, and add your camera stream as a data source\. Choose **Next**\.

1. On the **Configure** step, choose **Next**\.

1. Choose **Deploy**, and then choose **Done**\.

1. In the list of deployed applications, choose **aws\-panorama\-sample**\.

Refresh this page for updates, or use the following script to monitor the deployment from the command line\.

**Example monitor\-deployment\.sh**  

```
while true; do
  aws panorama list-application-instances --query 'ApplicationInstances[?Name==`aws-panorama-sample`]'
  sleep 10
done
```

```
[
    {
        "Name": "aws-panorama-sample",
        "ApplicationInstanceId": "applicationInstance-x264exmpl33gq5pchc2ekoi6uu",
        "DefaultRuntimeContextDeviceName": "my-appliance",
        "Status": "DEPLOYMENT_PENDING",
        "HealthStatus": "NOT_AVAILABLE",
        "StatusDescription": "Deployment Workflow has been scheduled.",
        "CreatedTime": 1630010747.443,
        "Arn": "arn:aws:panorama:us-west-2:123456789012:applicationInstance/applicationInstance-x264exmpl33gq5pchc2ekoi6uu",
        "Tags": {}
    }
]
[
    {
        "Name": "aws-panorama-sample",
        "ApplicationInstanceId": "applicationInstance-x264exmpl33gq5pchc2ekoi6uu",
        "DefaultRuntimeContextDeviceName": "my-appliance",
        "Status": "DEPLOYMENT_PENDING",
        "HealthStatus": "NOT_AVAILABLE",
        "StatusDescription": "Deployment Workflow has completed data validation.",
        "CreatedTime": 1630010747.443,
        "Arn": "arn:aws:panorama:us-west-2:123456789012:applicationInstance/applicationInstance-x264exmpl33gq5pchc2ekoi6uu",
        "Tags": {}
    }
]
...
```

If the application doesn't start running, check the [application and device logs](monitoring-logging.md) in Amazon CloudWatch Logs\.

## View the output<a name="gettingstarted-deploy-view"></a>

 When the deployment is complete, the application starts processing the video stream and sends logs to CloudWatch\.

**To view logs in CloudWatch Logs**

1. Open the [Log groups page of the CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\.

1. Find AWS Panorama application and appliance logs in the following groups:

****
   + **Device logs** – `/aws/panorama/devices/device-id`
   + **Application logs** – `/aws/panorama/devices/device-id/applications/instance-id`

```
2022-08-26 17:43:39 INFO     INITIALIZING APPLICATION
2022-08-26 17:43:39 INFO     ## ENVIRONMENT VARIABLES
{'PATH': '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', 'TERM': 'xterm', 'container': 'podman'...}
2022-08-26 17:43:39 INFO     Configuring parameters.
2022-08-26 17:43:39 INFO     Configuring AWS SDK for Python.
2022-08-26 17:43:39 INFO     Initialization complete.
2022-08-26 17:43:39 INFO     PROCESSING STREAMS
2022-08-26 17:46:19 INFO     epoch length: 160.183 s (0.936 FPS)
2022-08-26 17:46:19 INFO     avg inference time: 805.597 ms
2022-08-26 17:46:19 INFO     max inference time: 120023.984 ms
2022-08-26 17:46:19 INFO     avg frame processing time: 1065.129 ms
2022-08-26 17:46:19 INFO     max frame processing time: 149813.972 ms
2022-08-26 17:46:29 INFO     epoch length: 10.562 s (14.202 FPS)
2022-08-26 17:46:29 INFO     avg inference time: 7.185 ms
2022-08-26 17:46:29 INFO     max inference time: 15.693 ms
2022-08-26 17:46:29 INFO     avg frame processing time: 66.561 ms
2022-08-26 17:46:29 INFO     max frame processing time: 123.774 ms
```

To view the application's video output, connect the appliance to a monitor with an HDMI cable\. By default, the application shows any classification result that has more than 20% confidence\.

**Example [squeezenet\_classes\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/squeezenet_classes.json)**  

```
["tench", "goldfish", "great white shark", "tiger shark",
"hammerhead", "electric ray", "stingray", "cock", "hen", "ostrich",
"brambling", "goldfinch", "house finch", "junco", "indigo bunting",
"robin", "bulbul", "jay", "magpie", "chickadee", "water ouzel",
"kite", "bald eagle", "vulture", "great grey owl",
"European fire salamander", "common newt", "eft",
"spotted salamander", "axolotl", "bullfrog", "tree frog",
...
```

The sample model has 1000 classes including many animals, food, and common objects\. Try pointing your camera at a keyboard or coffee mug\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/mug.jpg)

For simplicity, the sample application uses a lightweight classification model\. The model outputs a single array with a probability for each of its classes\. Real\-world applications more frequently use object detection models that have multidimensional output\. For sample applications with more complex models, see [Sample applications, scripts, and templates](panorama-samples.md)\.

## Enable the SDK for Python<a name="gettingstarted-deploy-redeploy"></a>

The sample application uses the AWS SDK for Python \(Boto\) to send metrics to Amazon CloudWatch\. To enable this functionality, create a role that grants the application permission to send metrics, and redeploy the application with the role attached\.

The sample application includes a AWS CloudFormation template that creates a role with the permissions that it needs\. To create the role, use the `aws cloudformation deploy` command\.

```
$ aws cloudformation deploy --template-file aws-panorama-sample.yml --stack-name aws-panorama-sample-runtime --capabilities CAPABILITY_NAMED_IAM
```



**To redeploy the application**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose an application\.

1. Choose **Replace**\.

1. Complete the steps to deploy the application\. In the **Specify IAM role**, choose the role that you created\. Its name starts with `aws-panorama-sample-runtime`\.

1. When the deployment completes, open the [CloudWatch console](https://console.aws.amazon.com/cloudwatch/home#metricsV2:graph=~();namespace=~'AWSPanoramaApplication) and view the metrics in the `AWSPanoramaApplication` namespace\. Every 150 frames, the application logs and uploads metrics for frame processing and inference time\.

## Clean up<a name="gettingstarted-deploy-cleanup"></a>

If you are done working with the sample application, you can use the AWS Panorama console to remove it from the appliance\.

**To remove the application from the appliance**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose an application\.

1. Choose **Delete from device**\.

## Next steps<a name="gettingstarted-deploy-next"></a>

If you encountered errors while deploying or running the sample application, see [Troubleshooting](panorama-troubleshooting.md)\.

To learn more about the sample application's features and implementation, continue to [the next topic](gettingstarted-sample.md)\.