# Using the developer kit<a name="gettingstarted-devkit"></a>

The AWS Panorama Appliance Developer Kit is an appliance for developing and testing AWS Panorama applications\. You connect to the developer kit from your computer to run commands, view logs, and explore the AWS Panorama Application SDK\.

**Important**  
The AWS Panorama Appliance Developer Kit is not secured for use on production networks or workloads\. For more information, see [Security considerations for the AWS Panorama Appliance Developer Kit](security-devkit.md)\.

This tutorial provides an introduction to connecting to the developer kit with SSH, viewing logs, and using Python libraries in application code\.

**Topics**
+ [Prerequisites](#gettingstarted-devkit-prereqs)
+ [Connect with SSH](#gettingstarted-devkit-ssh)
+ [Get superuser access](#gettingstarted-devkit-sudo)
+ [View logs](#gettingstarted-devkit-logs)
+ [View the AWS Panorama Application SDK help](#gettingstarted-devkit-panoramasdk)
+ [Use the AWS SDK for Python \(Boto3\)](#gettingstarted-devkit-awssdk)
+ [Next steps](#gettingstarted-devkit-next)

## Prerequisites<a name="gettingstarted-devkit-prereqs"></a>

To connect to the developer kit and run commands, you must enable SSH during [setup](gettingstarted-setup.md)\.

**Important**  
Be sure to record the username and password for SSH\. They are not stored in AWS Panorama\. If you lose them, you must repeat the setup process\.

To follow the procedures in this tutorial, you need a command line terminal or shell to run commands\. In the code listings, commands are preceded by a prompt symbol \($\) and the name of the current directory, when appropriate\.

```
~/lambda-project$ this is a command
this is output
```

For long commands, we use an escape character \(`\`\) to split a command over multiple lines\.

On Linux and macOS, use your preferred shell and package manager\. On Windows 10, you can [install the Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to get a Windows\-integrated version of Ubuntu and Bash\.

This tutorial includes sample scripts that you can run on the developer kit as\-is or by replacing some values with your own\. For scripts and other resources that you want to save, you can create a directory under `/data` on the developer kit's local storage\. Files outside of `/data` are not saved when you update your developer kit's software\.

## Connect with SSH<a name="gettingstarted-devkit-ssh"></a>

The AWS Panorama Appliance Developer Kit reports its IP address to AWS Panorama\. You can find it in the AWS Panorama console, on the developer kit's settings page\. Use this address to connect to the developer kit with SSH\.

**To get the developer kit's IP address**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Settings**\.

1. Find the IP address under **Appliance network**\.

**Note**  
The developer kit renews its IP address lease with your network's DHCP server automatically\. If you disconnect the developer kit from your network for longer than the lease time\. it might be assigned a different IP address\. To avoid this, you can configure a static IP address during [the setup process](gettingstarted-setup.md)\.

To connect to the developer kit, use the `ssh` command with your username and the developer kit's IP address\.

```
$ ssh 10.24.34.0 -l me
me@10.24.34.0's password:
```

To end the session and return to your computer's shell, use the `exit` command\.

To copy logs and other files from the developer kit onto your computer, you can use the `scp` command\. The following example copies the AWS IoT job agent log from a developer kit to the current directory\.

```
$ scp me@10.0.0.100:/opt/aws/panorama/iot/jobs_agent.log .
me@10.0.0.100's password:
jobs_agent.log                                              100% 9049KB 372.4KB/s   00:24
```

## Get superuser access<a name="gettingstarted-devkit-sudo"></a>

To use some commands, you need to elevate your privileges\. To assume superuser privileges for a single command, use `sudo`\. For example, to view a protected log file, you can use the `sudo` command with `tail`\.

```
me@tegra-ubuntu$ sudo tail /var/log/awslogs.log
```

The first time you use `sudo`, you must enter your user password\. You can continue to run commands with `sudo` for a few minutes without entering your password again\. To avoid entering your password multiple times in a session, assume the privileges of the `root` user\.

```
me@tegra-ubuntu$ sudo -su root
root@tegra-ubuntu:/home/me# tail /var/log/awslogs.log
```

**Important**  
Be careful when using root privileges\. Making changes to the software or file system can have unintended consequences\. When you update the developer kit, change settings in the AWS Panorama console, or deploy applications, changes to the developer kit can be reverted\.

To exit superuser mode, use the `exit` command\.

## View logs<a name="gettingstarted-devkit-logs"></a>

AWS Panorama generates logs in several locations on the developer kit\. In addition to logs for your application code,AWS Panorama generates logs for camera streams, outputs, and AWS client processes\. The AWS Panorama Appliance sends many of these logs to Amazon CloudWatch Logs\.

Your application code's output log is stored under `/data/greengrass`, in a folder structure that includes your AWS Region, account number, and AWS Lambda function name\. To use the following example, replace the account ID and the name of the Lambda function with your own\.

**Example get\-app\-log\.sh \(requires sudo\) – Show application log**  

```
REGION=us-east-1
ACCOUNT=123456789012
FUNCTION=aws-panorama-sample-function
LOG=/data/greengrass/ggc/var/log/user/$REGION/$ACCOUNT/$FUNCTION.log
tail -100 $LOG
```

In addition to application logs, you can view the system logs for AWS IoT Greengrass\.

**Example list\-greengrass\-logs\.sh \(requires sudo\) – Show application log**  

```
PANORAMA=/opt/aws/panorama
IOT=$PANORAMA/iot
GREENGRASS=/data/greengrass/ggc/var/log/system
ls $IOT
ls $GREENGRASS
```

To view logs for cameras \(datasources\) and HDMI output \(datasinks\), navigate to the `mediapipeline` directory under `/opt/aws/panorama`\. Each camera and display has a separate log file\.

**Example list\-mediapipeline\-logs\.sh – Get a list of camera and display logs**  

```
PANORAMA=/opt/aws/panorama
PIPELINE=$PANORAMA/mediapipeline/bin
SOURCES=$PIPELINE/source_onvif-arn-aws-panorama-
SINKS=$PIPELINE/sink_hdmi-datasink-hdmi-
ls $SOURCES*
ls $SINKS*
```

The Amazon CloudWatch Logs agent outputs logs to `/var/log/awslogs.log`\. If you don't see logs for your developer kit in CloudWatch Logs, check this file for errors\.

**Example get\-cwl\-log\.sh \(requires sudo\) – Show CloudWatch Logs agent log**  

```
CWL=/var/log/awslogs.log
tail $CWL
```

For more information about using CloudWatch Logs to view logs, see [Viewing AWS Panorama event logs in CloudWatch Logs](monitoring-logging.md)\.

## View the AWS Panorama Application SDK help<a name="gettingstarted-devkit-panoramasdk"></a>

The AWS Panorama Application SDK is a Python library that is included in the developer kit's software image\. You use it in your application code to interact with the developer kit and model\.

To see information about the library, load it into a Python interpreter and use the `help` command\.

```
$ python3
Python 3.7.5

>>> import panoramasdk
>>> help(panoramasdk)

    CLASSES
        builtins.list(builtins.object)
            port
        builtins.object
            base
            batch
            batch_set
    ...
```

The documentation for each class shows details about its methods' behavior and parameters\.

For more information about the SDK, see [The AWS Panorama Application SDK](applications-panoramasdk.md)\.

## Use the AWS SDK for Python \(Boto3\)<a name="gettingstarted-devkit-awssdk"></a>

To access resources in other AWS services, you can use the SDK for Python in your application code\. When your application code runs, it gets permission to call AWS services from an AWS Identity and Access Management \(IAM\) role that is attached to the device\.

To call AWS services with the SDK for Python, import the library \(`boto3`\) and create a client\. The following example shows how to use an Amazon Simple Storage Service \(Amazon S3\) client to get a list of objects in an AWS Panorama artifacts bucket\.

```
$ python3
Python 3.7.5

>>> import boto3
>>> s3 = boto3.client('s3')
>>> bucket = 'aws-panorama-artifacts-123456789012'
>>> response = s3.list_objects(Bucket=bucket)
>>> for object in response['Contents']:
...     print(f'    {object["Key"]}')
...
ssd_512_resnet50_v1_voc.tar.gz
```

The AWS Panorama Appliance has limited permissions to access objects in buckets that include `aws-panorama` in the name, and a few other resources\. You can add permissions to the developer kit's service role \([AWSPanoramaGreengrassGroupRole](permissions-services.md)\)\.

## Next steps<a name="gettingstarted-devkit-next"></a>

If you encountered errors while connecting to the developer kit or running commands, see [Troubleshooting](panorama-troubleshooting.md)\.

Next, learn more about [AWS Panorama concepts](gettingstarted-concepts.md)\.