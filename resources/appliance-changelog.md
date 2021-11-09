# AWS Panorama Appliance software change log

The following sections detail updates to the AWS Panorama Appliance software, including changes to the operation system, AWS Panorama libraries, and the application SDK.

# 4.3.4

**Release date**: 2021-11-08

**Type**: Mandatory

## Logs

Updated device logs to include the full log type (`INFO`, `WARN`, `ERROR`). You can filter logs in the Amazon CloudWatch Logs console by entering `WARN` or `ERROR` in the search bar of a log stream (case sensitive).

Updated device controller logs (`occ_log`) to match the timestamp in the log to the timestamp in CloudWatch logs.

For more information about logs, see [Viewing AWS Panorama event logs in CloudWatch Logs](https://docs.aws.amazon.com/panorama/latest/dev/monitoring-logging.html)

## Model precision mode setting

Added `precisionMode` setting to the model descriptor schema. You can set this field to `FP16` to run the model with 16-bit floating-point precision, instead of 32-bit precision. Using lower precision significantly reduces inference time, but can affect accuracy.

When you update your model's descriptor file, reimport the model with the application CLI to apply the change. For an example descriptor file and update script, see the sample application.

Model descriptor: [packages/123456789012-SQUEEZENET_PYTORCH_V1-1.0/descriptor.json](/sample-apps/aws-panorama-sample/packages/123456789012-SQUEEZENET_PYTORCH_V1-1.0/descriptor.json)

Update script: [update-model-config.sh](/sample-apps/aws-panorama-sample/update-model-config.sh)

## Application SDK

**Version**: 1.0.0 (no change)

# 4.1.38

**Release date**: 2021-10-20

**Type**: Mandatory

## Application SDK

Version 1.0.0 of the application SDK replaces the application SDK from preview and changes the programming model for applications. If you have an application from preview, see the migration guide for more information.

**Version**: 1.0.0

**Reference docs**: [resources/applicationsdk-reference.md](/resources/applicationsdk-reference.md)

**Migration guide**: [Migrate applications from preview](https://docs.aws.amazon.com/panorama/latest/dev/applications-migrate.html)
