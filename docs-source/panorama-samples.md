# Sample applications, scripts, and templates<a name="panorama-samples"></a>

The GitHub repository for this guide provides sample applications, scripts and templates for AWS Panorama devices\. Use these samples to learn best practices and automate development workflows\.

**Topics**
+ [Sample applications](#samples-applications)
+ [Utility scripts](#samples-scripts)
+ [AWS CloudFormation templates](#samples-templates)

## Sample applications<a name="samples-applications"></a>

Sample applications demonstrate use of AWS Panorama features and common computer vision tasks\. These sample applications include scripts and templates that automate setup and deployment\. With minimal configuration, you can deploy and update applications from the command line\.

****
+ [aws\-panorama\-sample](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample) – Basic computer vision with a classification model\. Use the AWS SDK for Python \(Boto\) to upload metrics to CloudWatch, instrument preprocessing and inference methods, and configure logging\.
+ [debug\-server](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/debug-server) – [Open inbound ports](applications-ports.md) on the device and forward traffic to an application code container\. Use multithreading to run application code, an HTTP server, and an HTTP client simultaneously\.
+ [custom\-model](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/custom-model) – Export models from code and compile with SageMaker Neo to test compatibility with the AWS Panorama Appliance\. Build locally in a Python development, in a Docker container, or on an Amazon EC2 instance\. Export and compile all built\-in application models in Keras for a specific TensorFlow or Python version\.

For more sample applications, also visit the [aws\-panorama\-samples](https://github.com/aws-samples/aws-panorama-samples) repository\.

## Utility scripts<a name="samples-scripts"></a>

The scripts in the `util-scripts` directory manage AWS Panorama resources or automate development workflows\.

****
+ [register\-camera\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/register-camera.sh) – Register a camera\.
+ [deregister\-camera\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/deregister-camera.sh) – Delete a camera node\.
+ [push\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/push.sh) – Build, upload, and deploy and application\.
+ [rename\-package\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/rename-package.sh) – Rename a node package\. Updates directory names, configuration files, and the application manifest\.
+ [samplify\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/samplify.sh) – Replace your account ID with an example account ID, and restore backup configurations to remove local configuration\.
+ [update\-model\-config\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/update-model-config.sh) – Re\-add the model to the application after updating the descriptor file\.
+ [view\-logs\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/view-logs.sh) – View logs for an application instance\.

For usage details, see [the README](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts)\.

## AWS CloudFormation templates<a name="samples-templates"></a>

Use the AWS CloudFormation templates in the `cloudformation-templates` directory to create resources for AWS Panorama applications\.

****
+ [application\-role\.yml](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/cloudformation-templates/application-role.yml) – Create an application role\. The role includes permission to send metrics to CloudWatch\. Add permissions to the policy statement for other API operations that your application uses\.

The `create-stack.sh` script in this directory creates AWS CloudFormation stacks\. It takes a variable number of arguments\. The first argument is the name of the template, and the remaining arguments are overrides for parameters in the template\.

For example, the following comand creates an application role\.

```
$ ./create-stack.sh application-role
```