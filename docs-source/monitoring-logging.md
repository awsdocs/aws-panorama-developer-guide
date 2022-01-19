# Viewing AWS Panorama logs<a name="monitoring-logging"></a>

AWS Panorama reports application and system events to Amazon CloudWatch Logs\. When you encounter issues, you can use the event logs to help debug your AWS Panorama application or troubleshoot the application's configuration\. 

**To view logs in CloudWatch Logs**

1. Open the [Log groups page of the CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\.

1. Find AWS Panorama application and appliance logs in the following groups:

****
   + **Device logs** – `/aws/panorama/devices/device-id`
   + **Application logs** – `/aws/panorama/devices/device-id/applications/instance-id`

When you reprovision an appliance after updating the system software, you can also [view logs on the provisioning USB drive](#monitoring-logging-provisioning)\.

**Topics**
+ [Viewing device logs](#monitoring-logging-device)
+ [Viewing application logs](#monitoring-logging-application)
+ [Configuring application logs](#monitoring-logging-configuration)
+ [Viewing provisioning logs](#monitoring-logging-provisioning)

## Viewing device logs<a name="monitoring-logging-device"></a>

The AWS Panorama Appliance creates a log group for the device, and a group for each application instance that you deploy\. The device logs contain information about application status, software upgrades, and system configuration\.

**Device logs – `/aws/panorama/devices/device-id`**
+ `occ_log` – Output from the controller process\. This process coordinates application deployments and reports on the status of each application instance's nodes\.
+ `ota_log` – Output from the process that coordinates over\-the\-air \(OTA\) software upgrades\.
+ `syslog` – Output from the device's syslog process, which captures messages sent between processes\.
+ `logging_setup_logs` – Output from the process that configures the CloudWatch Logs agent\.
+ `cloudwatch_agent_logs` – Output from the CloudWatch Logs agent\.
+ `shadow_log` – Output from the [AWS IoT device shadow](https://docs.aws.amazon.com/iot/latest/developerguide/iot-device-shadows.html)\.

## Viewing application logs<a name="monitoring-logging-application"></a>

An application instance's log group contains a log stream for each node, named after the node\.

**Application logs – `/aws/panorama/devices/device-id/applications/instance-id`**
+ **Code** – Output from your application code and the AWS Panorama Application SDK\. Aggregates application logs from `/opt/aws/panorama/logs`\.
+ **Model** – Output from the process that coordinates inference requests with a model\.
+ **Stream** – Output from the process that decodes video from a camera stream\.
+ **Display** – Output from the process that renders video output for the HDMI port\.
+ `mds` – Logs from the appliance metadata server\.
+ `console_output` – Captures standard output and error streams from code containers\.

If you don't see logs in CloudWatch Logs, confirm that you are in the correct AWS Region\. If you are, there might be an issue with the appliance's connection to AWS or with permissions on [the appliance's AWS Identity and Access Management \(IAM\) role](permissions-services.md)\.

## Configuring application logs<a name="monitoring-logging-configuration"></a>

Configure a Python logger to write log files to `/opt/aws/panorama/logs`\. The appliance streams logs from this location to CloudWatch Logs\. To avoid using too much disk space, use a maximum file size of 10 MiB and a backup count of 1\. The following example shows a method that creates a logger\.

**Example [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py#L181) – Logger configuration**  

```
def get_logger(name=__name__,level=logging.INFO):
    logger = logging.getLogger(name)
    logger.setLevel(level)
    LOG_PATH = '/opt/aws/panorama/logs'
    handler = RotatingFileHandler("{}/app.log".format(LOG_PATH), maxBytes=10000000, backupCount=1)
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                    datefmt='%Y-%m-%d %H:%M:%S')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger
```

Initialize the logger at the global scope and use it throughout your application code\.

**Example [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py#L205) – Initialize logger**  

```
def main():
    try:
        logger.info("INITIALIZING APPLICATION")
        app = Application()
        logger.info("PROCESSING STREAMS")
        while True:
            app.process_streams()
            # turn off debug logging after 150 loops
            if logger.getEffectiveLevel() == logging.DEBUG and app.frame_num == 150:
                logger.setLevel(logging.INFO)
    except:
        logger.exception('Exception during processing loop.')

logger = get_logger(level=logging.INFO)
main()
```

## Viewing provisioning logs<a name="monitoring-logging-provisioning"></a>

During provisioning, the AWS Panorama Appliance copies logs to the USB drive that you use to transfer the configuration archive to the appliance\. Use these logs to troubleshoot provisioning issues on appliances with the latest software version\.

**Important**  
Provisioning logs are available for appliances updated to software version 4\.3\.23 or newer\.

**Application logs**
+ `/panorama/occ.log` – AWS Panorama controller software logs\.
+ `/panorama/ota_agent.log` – AWS Panorama over\-the\-air update agent logs\.
+ `/panorama/syslog.log` – Linux system logs\.
+ `/panorama/kern.log` – Linux kernel logs\.