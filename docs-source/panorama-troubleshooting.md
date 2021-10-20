# Troubleshooting<a name="panorama-troubleshooting"></a>

The following topics provide troubleshooting advice for errors and issues that you might encounter when using the AWS Panorama console, appliance, or SDK\. If you find an issue that is not listed here, use the **Provide feedback** button on this page to report it\.

You can find logs for your appliance in [the Amazon CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\. The appliance uploads logs from your application code, the appliance software, and AWS IoT processes as they are generated\. For more information, see [Viewing AWS Panorama event logs in CloudWatch Logs](monitoring-logging.md)\.

For more troubleshooting advice and answers to common support questions, visit the [AWS Knowledge Center](https://aws.amazon.com/premiumsupport/knowledge-center/)\.

## Appliance configuration<a name="troubleshooting-appliance"></a>

**Issue:** *The appliance shows a blank screen during boot up\.*

After completing the initial boot sequence, which takes about one minute, the appliance shows a blank screen for a minute or more while it loads your model and starts your application\. Also, the appliance does not output video if you connect a display after it turns on\.

**Issue:** *The appliance doesn't respond when I hold the power button down to turn it off\.*

The appliance takes up to 10 seconds to shut down safely\. You need to hold the power button down for only 1 second to start the shutdown sequence\. For a complete list of button operations, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.

**Issue:** *I need to generate a new configuration archive to change settings or replace a lost certificate\.*

AWS Panorama does not store the device certificate or network configuration after you download it, and you can't reuse configuration archives\. Delete the appliance using the AWS Panorama console and create a new one with a new configuration archive\.