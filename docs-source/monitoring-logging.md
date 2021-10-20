# Viewing AWS Panorama event logs in CloudWatch Logs<a name="monitoring-logging"></a>

AWS Panorama reports application and system events to Amazon CloudWatch Logs\. When you encounter issues, you can use the event logs to help debug your AWS Panorama application or to troubleshoot the application's configuration\. 

**To view logs in CloudWatch Logs**

1. Open the [Log groups page of the CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\.

1. Find AWS Panorama application and appliance logs in the following groups:

****
   + **AWS Panorama Appliance system** – `/aws/panorama/devices/device-id`
   + **Application instance** – `/aws/panorama/devices/device-id/applications/instance-id`

The AWS Panorama Appliance creates a log group for the device, and a group for each application instance that you deploy\. The device contain information about application status, software upgrades, and system configuration\. 

**Device logs**
+ `occ_log` – Output from the controller process\. This process coordinates application deployments and reports on the status of each application instance's nodes\.
+ `ota_log` – Output from the process that coordinates over\-the\-air \(OTA\) software upgrades\.
+ `syslog` – Output from the device's syslog process, which captures messages sent between processes\.
+ `logging_setup_logs` – Output from the process that configures the CloudWatch Logs agent\.
+ `cloudwatch_agent_logs` – Output from the CloudWatch Logs agent\.
+ `shadow_log` – Output from the [AWS IoT device shadow](https://docs.aws.amazon.com/iot/latest/developerguide/iot-device-shadows.html)\.

An application instance's log group contains a log stream for each node, named after the node\.

**Application logs**
+ **Code** – Output from your application code and the AWS Panorama Application SDK\. Aggregates application logs from `/opt/aws/panorama/logs`\.
+ **Model** – Output from the process that coordinates inference requests with a model\.
+ **Stream** – Output from the process that decodes video from a camera stream\.
+ **Display** – Output from the process that renders video output for the HDMI port\.
+ `mds` – Logs from the appliance metadata server\.

If you don't see logs in CloudWatch Logs, confirm that you are in the correct AWS Region\. If you are, there might be an issue with the appliance's connection to AWS or with permissions on [the appliance's AWS Identity and Access Management \(IAM\) role](permissions-services.md)\.