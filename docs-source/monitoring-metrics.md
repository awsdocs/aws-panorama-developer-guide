# Monitoring appliances and applications with Amazon CloudWatch<a name="monitoring-metrics"></a>

When an appliance is online, AWS Panorama sends metrics to Amazon CloudWatch\. You can build graphs and dashboards with these metrics in the CloudWatch console to monitor appliance activity, and set alarms that notify you when devices go offline or applications encounter errors\.

**To view metrics in the CloudWatch console**

1. Open the [AWS Panorama console Metrics page](https://console.aws.amazon.com/cloudwatch/home#metricsV2:graph=~();namespace=~'PanoramaDeviceMetrics) \(`PanoramaDeviceMetrics` namespace\)\.

1. Choose a dimension schema\.

1. Choose metrics to add them to the graph\.

1. To choose a different statistic and customize the graph, use the options on the **Graphed metrics** tab\. By default, graphs use the `Average` statistic for all metrics\. 

**Pricing**  
CloudWatch has an Always Free tier\. Beyond the free tier threshold, CloudWatch charges for metrics, dashboards, alarms, logs, and insights\. For details, see [CloudWatch pricing](https://aws.amazon.com/cloudwatch/pricing/)\.

For more information about CloudWatch, see the [https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/](https://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/)\.

**Topics**
+ [Using device metrics](#monitoring-cloudwatch-device)
+ [Using application metrics](#monitoring-cloudwatch-application)
+ [Configuring alarms](#monitoring-cloudwatch-alarms)

## Using device metrics<a name="monitoring-cloudwatch-device"></a>

When an appliance is online, it sends metrics to Amazon CloudWatch\. You can use these metrics to monitor device activity and trigger an alarm if devices go offline\.
+ `DeviceActive` – Sent periodically when the device is active\.

  Dimensions – `DeviceId` and `DeviceName`\.

View the `DeviceActive` metric with the `Average` statistic\.

## Using application metrics<a name="monitoring-cloudwatch-application"></a>

When an application encounters an error, it sends metrics to Amazon CloudWatch\. You can use these metrics to trigger an alarm if an application stops running\.
+ `ApplicationErrors` – The number of application errors recorded\.

  Dimensions – `ApplicationInstanceName` and `ApplicationInstanceId`\.

View the application metrics with the `Sum` statistic\.

## Configuring alarms<a name="monitoring-cloudwatch-alarms"></a>

To get notifications when a metric exceeds a threshold, create an alarm\. For example, you can create an alarm that sends a notification when the sum of the `ApplicationErrors` metric stays at 1 for 20 minutes\.

**To create an alarm**

1. Open the [Amazon CloudWatch console Alarms page](https://console.aws.amazon.com/cloudwatch/home#alarmsV2:)\.

1. Choose **Create alarm**\.

1. Choose **Select metric** and locate a metric for your device, such as `ApplicationErrors` for `applicationInstance-gk75xmplqbqtenlnmz4ehiu7xa`,`my-application`\.

1. Follow the instructions to configure a condition, action, and name for the alarm\. 

For detailed instructions, see [Create a CloudWatch alarm](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ConsoleAlarms.html) in the *Amazon CloudWatch User Guide*\.