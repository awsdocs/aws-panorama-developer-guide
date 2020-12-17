# Viewing AWS Panorama event logs in CloudWatch Logs<a name="monitoring-logging"></a>

AWS Panorama reports application events and system events to CloudWatch Logs\. You can use the event logs to help debugging your AWS Panorama application or troubleshoot application configuration when you encounter any issues\. 

To debug and validate that your code is working as expected, you can output logs with the standard logging functionality for Python\. You can view logs in the CloudWatch Logs console\.

**To view logs in CloudWatch Logs**

1. Open the [Log groups page of the CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)

1. Find AWS Panorama application and appliance logs in the following groups:

****
   + **Application code** – `/aws/greengrass/Lambda/us-east-1/123456789012/function-name`

     Replace the highlighted values with your AWS Region, account ID, and function name\.
   + **AWS IoT Greengrass system** – `/aws/greengrass/GreengrassSystem/component-name`
   + **AWS Panorama Appliance system** – `/aws/panorama_device/iot-thing-name`

     Log streams include `syslog`, `iot_job_agent`, `mediapipeline`, and a stream for each camera\.

If you don't see logs in CloudWatch Logs, confirm that you are in the correct AWS Region\. If you are, there might be an issue with the appliance's connection to AWS, or with permissions on [the appliance's AWS Identity and Access Management \(IAM\) role](permissions-services.md)\.

With the AWS Panorama Appliance Developer Kit, you can connect to the appliance over a local network to view logs and configuration files\. For more information, see [Using the developer kit](gettingstarted-devkit.md)\.