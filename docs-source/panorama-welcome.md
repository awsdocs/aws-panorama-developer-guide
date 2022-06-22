# What is AWS Panorama?<a name="panorama-welcome"></a>

AWS Panorama is a service that brings computer vision to your on\-premises camera network\. You install the AWS Panorama Appliance or another compatible device in your datacenter, register it with AWS Panorama, and deploy computer vision applications from the cloud\. AWS Panorama works with your existing real time streaming protocol \(RTSP\) network cameras\. The appliance runs secure computer vision applications from [AWS Partners](https://aws.amazon.com//panorama/partners/), or applications that you build yourself with the AWS Panorama Application SDK\.

The AWS Panorama Appliance is a compact edge appliance that uses a powerful system\-on\-module \(SOM\) that is optimized for machine learning workloads\. The appliance can run multiple computer vision models against multiple video streams in parallel and output the results in real time\. It is designed for use in commercial and industrial settings and is rated for dust and liquid protection \(IP\-62\)\.

The AWS Panorama Appliance enables you to run self\-contained computer vision applications at the edge, without sending images to the AWS Cloud\. By using the AWS SDK, you can integrate with other AWS services and use them to track data from the application over time\. By integrating with other AWS services, you can use AWS Panorama to do the following:

****
+ **Analyze traffic patterns** – Use the AWS SDK to record data for retail analytics in Amazon DynamoDB\. Use a serverless application to analyze the collected data over time, detect anomalies in the data, and predict future behavior\.
+ **Receive site safety alerts** – Monitor off\-limits areas at an industrial site\. When your application detects a potentially unsafe situation, upload an image to Amazon Simple Storage Service \(Amazon S3\) and send a notification to an Amazon Simple Notification Service \(Amazon SNS\) topic so recipients can take corrective action\.
+ **Improve quality control** – Monitor an assembly line's output to identify parts that don't conform to requirements\. Highlight images of nonconformant parts with text and a bounding box and display them on a monitor for review by your quality control team\.
+ **Collect training and test data** – Upload images of objects that your computer vision model couldn't identify, or where the model's confidence in its guess was borderline\. Use a serverless application to create a queue of images that need to be tagged\. Tag the images and use them to retrain the model in Amazon SageMaker\.

AWS Panorama uses other AWS services to manage the AWS Panorama Appliance, access models and code, and deploy applications\. AWS Panorama does as much as possible without requiring you to interact with other services, but a knowledge of the following services can help you understand how AWS Panorama works\.

****
+ [SageMaker](https://aws.amazon.com/sagemaker/) – You can use SageMaker to collect training data from cameras or sensors, build a machine learning model, and train it for computer vision\. AWS Panorama uses SageMaker Neo to optimize models to run on the AWS Panorama Appliance\.
+ [Amazon S3](https://aws.amazon.com/s3/) – You use Amazon S3 access points to stage application code, models, and configuration files for deployment to an AWS Panorama Appliance\.
+ [AWS IoT](https://aws.amazon.com/iot/) – AWS Panorama uses AWS IoT services to monitor the state of the AWS Panorama Appliance, manage software updates, and deploy applications\. You don't need to use AWS IoT directly\.

To get started with the AWS Panorama Appliance and learn more about the service, continue to [Getting started with AWS Panorama](panorama-gettingstarted.md)\.