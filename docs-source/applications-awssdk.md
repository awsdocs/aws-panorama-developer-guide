# AWS SDK for Python \(Boto3\)<a name="applications-awssdk"></a>

You can use the AWS SDK for Python \(Boto\) to call AWS services from your application code\. For example, if your model detects something out of the ordinary, you could post metrics to Amazon CloudWatch, send an notification with Amazon SNS, save an image to Amazon S3, or invoke a Lambda function for further processing\. Most AWS services have a public API that you can use with the AWS SDK\.

The appliance does not have permission to access all AWS services by default\. To grant it permission, add the API actions that it uses to the appliance's role \([AWSPanoramaGreengrassGroupRole](permissions-services.md)\)\. You create this role when you first use the AWS Panorama console; it comes with limited permission to use Amazon S3 CloudWatch, and Amazon CloudWatch Logs\.

**Topics**
+ [Using Amazon S3](#applications-awssdk-s3)
+ [Using the AWS IoT MQTT topic](#monitoring-messagestream)

## Using Amazon S3<a name="applications-awssdk-s3"></a>

You can use Amazon S3 to store processing results and other application data\.

```
import boto3
s3_client=boto3.client("s3")
s3_clients3.upload_file(data_file,
                    s3_bucket_name,
                    os.path.basename(data_file))
```

The appliance has permission to access buckets that include `aws-panorama` in the name\. To grant it additional permission, you can modify the appliance's role \([AWSPanoramaGreengrassGroupRole](permissions-services.md)\)\.

## Using the AWS IoT MQTT topic<a name="monitoring-messagestream"></a>

You can use the SDK for Python \(Boto3\) to send messages to an [MQTT topic](https://docs.aws.amazon.com/iot/latest/developerguide/topics.html) in AWS IoT\. In the following example, the application posts to a topic named after the appliance's *thing name*, which you can find in [AWS IoT console](https://console.aws.amazon.com/iot/home#/thinghub)\.

```
import boto3
iot_client=boto3.client('iot-data')
topic = "panorama/panorama_my-appliance_Thing_a01e373b"
iot_client.publish(topic=topic, payload="my message")
```

The topic name can be anything\. To publish messages, the device needs permission to call `iot:Publish`\.

**To monitor an MQTT queue**

1. Open the [AWS IoT console Test page](https://console.aws.amazon.com/iot/home?region=us-east-1#/test)\.

1. For **Subscription topic**, enter the name of the topic\. For example, `panorama/panorama_my-appliance_Thing_a01e373b`\.

1. Choose **Subscribe to topic**\.