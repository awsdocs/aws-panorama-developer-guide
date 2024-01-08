# AWS Panorama Appliance software change log

The following sections detail updates to the AWS Panorama Appliance software, including changes to the operation system, AWS Panorama libraries, the application SDK, and the application container image.

# Device software version 7.0.13

**Release date** 2023-12-28

**Type**: Optional

## Network requirements

With this update, the appliance uses additional AWS services to manage software updates. If you restrict network communication outbound from the appliance, or connect it to a private VPC subnet, you must allow access to additional endpoints and ports before applying the update.

- Amazon ECR service and Docker registry endpoints
- AWS IoT Core credential provider endpoints
- AWS IoT Core data plane endpoints (additional ports)

For details on ports and endpoints used by the AWS Panorama Appliance, see [Network setup](https://docs.aws.amazon.com/panorama/latest/dev/appliance-network.html).

If you connect your appliance to a private VPC subnet, create VPC endpoints for these services and, for IoT Core, add an additional Route53 record set for subdomains of the credentials endpoint. For more information, see [Using VPC endpoints](https://docs.aws.amazon.com/panorama/latest/dev/api-endpoints.html).

This repo provides a CloudFormation template that demonstrates how to configure VPC endpoints, hosted zones, and record sets in your private subnets: [vpc-appliance.yml](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/cloudformation-templates/vpc-appliance.yml)

## Bug fixes

Fixed an issue that causes connectivity issues in application containers when using custom DNS settings.

# Device software version 7.0.11

**Release date**: 2023-11-08

**Type**: Optional

## RECALLED

This release is recalled due to an issue that causes connectivity issues in application containers when using custom DNS settings.

If your appliance is affected, you can revert to the previous version 6.2.1 by choosing **Install software update** in the device settings menu. For more information, see [Update the appliance software](https://docs.aws.amazon.com/panorama/latest/dev/appliance-manage.html#appliance-manage-software).

# Application base image 1.2.0-py3.8

**Release date**: 2023-10-17

**Application SDK**: 1.2.0

**Python** : 3.8.0

**NumPy** : 1.24.3

**Image URI**: `public.ecr.aws/panorama/panorama-application:1.2.0-py3.8`

This release updates Python to version 3.8 in the base image. For all available tags, see https://gallery.ecr.aws/panorama/panorama-application

# Device software version 6.2.1

**Release date**: 2023-09-06

**Type**: Optional

## Bug fixes

Fixed an issue that caused the appliance to appear offline after a network interruption.

# Device software version 6.0.8

**Release date**: 2023-07-06

**Type**: Required

## Updates

Updated error handling to improve interoperability with media gateways.

Updates to improve system stability, performance, and security.

# Device software version 5.1.7

**Release date**: 2023-03-31

**Type**: Optional

## Bug fixes

Fixed a race condition that caused disk corruption during shutdown, and improved autorecovery from disk corruption.

Improved error handling for unsupported (non-H.264) RTSP stream encodings.

Improved camera stream connection retry behavior to improve interoperability with media gateways.

# Device software version 5.0.74

**Release date**: 2023-01-23

**Type**: Optional

## Error handling

Improved error handling for input port configuration issues.

## Bug fixes

Fixed an issue that caused applications to crash after rebooting the device.


# Device software version 5.0.42

**Release date**: 2022-11-16

**Type**: Optional

## Error handling

Improved format and usability of application logs.

## Bug fixes

Fixed an issue that caused application state to be incorrect after power loss.

Fixed an issue that caused application files to remain on the appliance after the application instance is removed.

Fixed an issue that caused storage and memory metrics to be shown in incorrect units in Amazon CloudWatch.

# Application base image 1.2

**Release date**: 2022-11-16

**Application SDK**: 1.2.0

**Python** : 3.7.5

**NumPy** : 1.18.2

Version 1.2 of the application SDK adds a `timeout` parameter to `video_in.get()`. If you specify a timeout, the SDK raises  `TimeoutException` if no frames are received within the specified number of seconds. The default behavior, which blocks the thread until a frame is received, is unchanged.

The SDK now sets the `AWS_REGION` environment variable to the device's AWS Region. You can use the AWS SDK for Python in your application without specifying a Region in code or your container image, and the device's Region is used automatically.

Improved error handling for `self.call()` to check model name against manifest and raise `KeyError` if the model is not in the application.

Improved error handling for `put()` to raise `ValueError` if the input frame list is empty.

Fixed a race condition in `video_in.get()` that caused the SDK to return old frames with `is_cached` set instead of blocking until at least one new frame is received. `is_cached` should only be set when a batch of frames from multiple sources includes some old frames and some new.

# Device software version 5.0.7

**Release date**: 2022-10-13

**Type**: Optional

## JetPack 4.6.2

**BREAKING** This release upgrades NVIDIA JetPack software on the appliance. After the update, deployed models will stop working due to the changes. Redeploy your applications to compile models against the new software version. If you use GPU access in your application container, recompile your application with libraries supported by [JetPack 4.6.2](https://developer.nvidia.com/embedded/jetpack-sdk-462). 

## Appliance reboot

You can use the AWS Panorama console or API to reboot an appliance remotely. For more information, see [Reboot an appliance](https://docs.aws.amazon.com/panorama/latest/dev/appliance-manage.html#appliance-manage-reboot) and [Manage appliances with the AWS Panorama API](https://docs.aws.amazon.com/panorama/latest/dev/api-appliance.html).

## Pause camera streams

You can pause and resume camera streams with the AWS Panorama API. When a camera stream is paused, your application doesn't receive images from that stream. You can connect multiple streams to an application and use pause and resume to switch between them. For more information, see [Manage applications with the AWS Panorama API](https://docs.aws.amazon.com/panorama/latest/dev/api-applications.html)

## Error handling

Improved format and usability of deployment-related logs.

## Bug fixes

Fixed an issue that caused applications with multiple input streams to only display 1 output, instead of tiling the output.

Fixed an issue that caused application logs to have incorrect timestamps in CloudWatch logs.

Fixed an issue that allowed two code nodes to run side-by-side in one application.

# Appliance software 4.3.93
​
**Release date**: 2022-08-24

**Type**: Optional
​
## Bug fixes
​
Fixed an issue that causes the device to go offline and require a factory reset. To learn how to perform a factory reset, see [Power and reset buttons](https://docs.aws.amazon.com/panorama/latest/dev/appliance-buttons.html#appliance-buttons-reset).

Fixed an issue that prevents you from removing faulty applications from the appliance.
​
## Log egress
​
You can use a USB drive to get an encrypted log image off of the device. The AWS Panorama service team can decrypt the logs on your behalf and assist in debugging. For more information, see [Egressing logs from a device](https://docs.aws.amazon.com/panorama/latest/dev/monitoring-logging.html#monitoring-logging-egress).

# Appliance software 4.3.72

**Release date**: 2022-06-23

**Type**: Optional

## Bug fixes

Fixed an issue that caused cameras to disconnect with a *dqBuffer(131) Failed due to Resource temporarily unavailable after retry* error.

Fixed an issue that caused an *apparmor="DENIED"* error to appear in appliances' `kern_log` log stream.

Updates to improve system stability, performance, and security.

# Appliance software 4.3.55

**Release date**: 2022-05-05

**Type**: Optional

## Logs

The `console_output` log now rotates automatically and uses a maximum of 11 MB of storage on the appliance.

For more information, see [Viewing AWS Panorama logs](https://docs.aws.amazon.com/panorama/latest/dev/monitoring-logging.html).

# Application base image 1.1.0

Version 1.1 of the application SDK adds `is_cached` and `stream_id` attributes to the `media` type.

Improved support for the `threading` library. The application SDK doesn't block other threads while waiting for inference with `node.call`.

Removed unused components to reduce size of application container images.

**Release date**: 2022-03-29

**Application SDK**: 1.1.0

**Python** : 3.7.5

**NumPy** : 1.18.2

**Reference docs**: [resources/applicationsdk-reference.md](/resources/applicationsdk-reference.md)

# Appliance software 4.3.45

**Release date**: 2022-03-24

**Type**: Required

## GPU access

You can access the graphics processor (GPU) on the device to use GPU-accelerated libraries, or run machine learning models in your application code. To turn on GPU access, you add GPU access as a requirement to the package configuration after building your application code container.

For more information, see [Using the GPU](https://docs.aws.amazon.com/panorama/latest/dev/applications-gpuaccess.html).

## Inbound ports

You can monitor or debug applications locally by running an HTTP server or other listener alongside your application code. To serve external traffic, you map ports on the device to ports on your application container.

A new sample application, [debug-server](https://github.com/awsdocs/aws-panorama-developer-guide/tree/main/sample-apps/debug-server), demonstrates how to use inbound ports to serve HTTP traffic. It uses multithreading to run application code, an HTTP server, and an HTTP client simultaneously. After running for a few minutes, the application sends an HTTP request to the device over the local network that signals it to restart the application code.

For more information, see [Serving inbound traffic](https://docs.aws.amazon.com/panorama/latest/dev/applications-gpuaccess.html).

## Logs

Added `kern_log` to appliance log streams to capture Linux kernel events. For more information, see [Viewing AWS Panorama logs](https://docs.aws.amazon.com/panorama/latest/dev/monitoring-logging.html).

# Appliance software 4.3.35

**Release date**: 2022-02-22

**Type**: Optional

Updated system software and libraries.

Removed unused packages to reduce image size and complexity.

Applied fix for [CVE-2021-4034](https://nvd.nist.gov/vuln/detail/CVE-2021-4034).

# Appliance software 4.3.23

**Release date**: 2022-01-13

**Type**: Mandatory

## NTP settings

You can now configure the AWS Panorama Appliance to use a specific NTP server for clock syncronization. Configure NTP settings during appliance setup with other networking settings.


## Model framework version setting

Added the `frameworkVersion` setting for model descriptor files in [#7](https://github.com/awsdocs/aws-panorama-developer-guide/pull/7/files). For TensorFlow and PyTorch models, you can specify the version of the framework that you used to build the model. This setting is passed on to SageMaker Neo ([FrameworkVersion parameter](https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_InputConfig.html#sagemaker-Type-InputConfig-FrameworkVersion)) when AWS Panorama compiles the model. SageMaker Neo currently supports the following values:

TensorFlow: 1.5, 2.4

PyTorch: 1.4, 1.5, 1.6, 1.7, 1.8

## Provisioning logs

The appliance now writes logs to the USB drive during provisioning. This feature is available when you reprovision a device after updating it to this version.

## Bug fixes

Fixed an issue that caused the appliance to stop trying to connect to inactive cameras after a few minutes.

Fixed an issue that sometimes caused active nodes to be reported as inactive.

Fixed an issue that sometimes caused applications to crash.

Fixed an issue that sometimes caused the appliance software to crash.

# Appliance software 4.3.4

**Release date**: 2021-11-08

**Type**: Mandatory

## Logs

Updated device logs to include the full log type (`INFO`, `WARN`, `ERROR`). You can filter logs in the Amazon CloudWatch Logs console by entering `WARN` or `ERROR` in the search bar of a log stream (case sensitive).

Updated device controller logs (`occ_log`) to match the timestamp in the log to the timestamp in CloudWatch logs.

For more information about logs, see [Viewing AWS Panorama event logs in CloudWatch Logs](https://docs.aws.amazon.com/panorama/latest/dev/monitoring-logging.html)

## Model precision mode setting

Added `precisionMode` setting to the [model descriptor schema](/resources/manifest-schema/ver_2021-01-01/assetDescriptor.schema.json). You can set this field to `FP16` to run the model with 16-bit floating-point precision, instead of 32-bit precision. Using lower precision significantly reduces inference time, but can affect accuracy.

When you update your model's descriptor file, reimport the model with the application CLI to apply the change. For an example descriptor file and update script, see the sample application.

Model descriptor: [packages/123456789012-SQUEEZENET_PYTORCH_V1-1.0/descriptor.json](/sample-apps/aws-panorama-sample/packages/123456789012-SQUEEZENET_PYTORCH_V1-1.0/descriptor.json)

Update script: [update-model-config.sh](/sample-apps/aws-panorama-sample/update-model-config.sh)

# 4.1.38

**Release date**: 2021-10-20

**Type**: Mandatory

Adds support for application base image v1.0.

# Application base image 1.0.0

Version 1.0 of the application SDK replaces the application SDK from preview and changes the programming model for applications.

**Application SDK**: 1.0.0

**Python** : 3.7.5

**NumPy** : 1.18.2

**Reference docs**: [resources/applicationsdk-reference.md](/resources/applicationsdk-reference.md)

