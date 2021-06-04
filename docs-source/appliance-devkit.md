# The AWS Panorama Appliance Developer Kit<a name="appliance-devkit"></a>

The AWS Panorama Appliance Developer Kit is a version of the AWS Panorama Appliance hardware that has developer features enabled\. With the AWS Panorama Appliance Developer Kit, you can connect to the appliance over SSH to run commands\.

**Important**  
The AWS Panorama Appliance Developer Kit is not secured for use on production networks or workloads\. For more information, see [Security considerations for the AWS Panorama Appliance Developer Kit](security-devkit.md)\.

If you are using the AWS Panorama Appliance Developer Kit for the first time, follow the tutorial at [Using the AWS Panorama Appliance Developer Kit](gettingstarted-devkit.md)\. The tutorial provides an introduction to connecting to the device with SSH, viewing logs, and using Python libraries\.

**Topics**
+ [Connecting with SSH](#appliance-devkit-ssh)
+ [Local storage](#appliance-devkit-storage)
+ [Granting additional permissions](#appliance-devkit-permissions)
+ [Logs](#appliance-devkit-logs)

## Connecting with SSH<a name="appliance-devkit-ssh"></a>

If you configured SSH access when you [set up the appliance](gettingstarted-setup.md), you can connect to it from the command line to view logs, test Python scripts, and inspect the device's configuration\.

To connect to the appliance with SSH, use the `ssh` command with the username and password that you configured during setup\.

```
$ ssh 10.24.34.0 -l me
me@10.24.34.0's password:
```

## Local storage<a name="appliance-devkit-storage"></a>

To store your application code locally on the appliance, use the `/data` directory\. You can use this space to store scripts and other resources\.

**Warning**  
Do not use the user directory under `/home` for local storage\. This directory is reset when you update your appliance\. Files that you add there are deleted\.

## Granting additional permissions<a name="appliance-devkit-permissions"></a>

The AWS Panorama Appliance Developer Kit has an AWS Identity and Access Management \(IAM\) role that grants it limited permission to access resources in your account\. You create this role, AWSPanoramaGreengrassGroupRole, when you first use the AWS Panorama console\.

By default, the appliance has permission to upload logs to CloudWatch Logs, to post metrics to CloudWatch, and to access objects in buckets that you create for use with AWS Panorama\. You can add permissions to the role to give the appliance and your application code permission to use additional AWS services\.

**To extend the appliance's permissions**

1. Open [the AWSPanoramaGreengrassGroupRole role](https://console.aws.amazon.com/iam/home#/roles/AWSPanoramaGreengrassGroupRole) in the IAM console\.

1. Choose **Attach policies**\.

1. Attach a policy that grants permission to use an AWS service\.

For more information on permissions in AWS Panorama, see [AWS Panorama permissions](panorama-permissions.md)\.

## Logs<a name="appliance-devkit-logs"></a>

After connecting to the appliance with SSH, you can find logs in the following locations\.

****
+ **Application code** – `/data/greengrass/ggc/var/log/user/us-east-1/123456789012/function-name.log`

  Replace the highlighted values with your AWS Region, account ID, and function name\.
+ **Appliance software** – `/var/log/syslog`, `/opt/aws/panorama/mediapipeline`
+ **AWS IoT Greengrass system** – `/data/greengrass/ggc/var/log/system`
+ **AWS IoT agents** – `/opt/aws/panorama/iot`
+ **CloudWatch Logs agent** – `/var/log/awslogs.log`, `/var/log/log_daemon.log`

Most of these logs are also sent to CloudWatch Logs\. For more information, see [Monitoring AWS Panorama resources and applications](panorama-monitoring.md)\.

For a tutorial that introduces the AWS Panorama Appliance Developer Kit and debugging, see [Using the AWS Panorama Appliance Developer Kit](gettingstarted-devkit.md)