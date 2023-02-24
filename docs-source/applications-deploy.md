# Deploy an application<a name="applications-deploy"></a>

To deploy an application, you use the AWS Panorama Application CLI import it to your account, build the container, upload and register assets, and create an application instance\. This topic goes into each of these steps in detail and describes what goes on in the background\.

If you have not deployed an application yet, see [Getting started with AWS Panorama](panorama-gettingstarted.md) for a walkthrough\.

For more information on customizing and extending the sample application, see [Building AWS Panorama applications](panorama-development.md)\.

**Topics**
+ [Install the AWS Panorama Application CLI](#applications-deploy-install)
+ [Import an application](#applications-deploy-import)
+ [Build a container image](#applications-deploy-build)
+ [Import a model](#applications-deploy-model)
+ [Upload application assets](#applications-deploy-package)
+ [Deploy an application with the AWS Panorama console](#applications-manage-deploy)
+ [Automate application deployment](#applications-deploy-automate)

## Install the AWS Panorama Application CLI<a name="applications-deploy-install"></a>

To install the AWS Panorama Application CLI and AWS CLI, use pip\.

```
$ pip3 install --upgrade awscli panoramacli
```

To build application images with the AWS Panorama Application CLI, you need Docker\. On Linux, `qemu` and related system libraries are required as well\. For more information on installing and configuring the AWS Panorama Application CLI, see the README file in the project's GitHub repository\.

****
+ [github\.com/aws/aws\-panorama\-cli](https://github.com/aws/aws-panorama-cli)

For instructions on setting up a build environment in Windows with WSL2, see [Setting up a development environment in Windows](applications-devenvwindows.md)\.

## Import an application<a name="applications-deploy-import"></a>

If you are working with a sample application or an application provided by a third party, use the AWS Panorama Application CLI to import the application\. 

```
my-app$ panorama-cli import-application
```

This command renames application packages with your account ID\. Package names start with the account ID of the account to which they are deployed\. When you deploy an application to multiple accounts, you must import and package the application separately for each account\.

For example, this guide's sample application a code package and a model package, each named with a placeholder account ID\. The `import-application` command renames these to use the account ID that the CLI infers from your workspace's AWS credentials\.

```
/aws-panorama-sample
├── assets
├── graphs
│   └── my-app
│       └── [graph\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/graphs/my-app/graph.json)
└── packages
    ├── [123456789012\-SAMPLE\_CODE\-1\.0](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0)
    │   ├── Dockerfile
    │   ├── application.py
    │   ├── descriptor.json
    │   ├── package.json
    │   ├── requirements.txt
    │   └── squeezenet_classes.json
    └── [123456789012\-SQUEEZENET\_PYTORCH\-1\.0](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SQUEEZENET_PYTORCH-1.0)
        ├── descriptor.json
        └── package.json
```

`123456789012` is replaced with your account ID in the package directory names, and in the application manifest \(`graph.json`\), which refers to them\. You can confirm your account ID by calling `aws sts get-caller-identity` with the AWS CLI\.

```
$ aws sts get-caller-identity
{
    "UserId": "AIDAXMPL7W66UC3GFXMPL",
    "Account": "210987654321",
    "Arn": "arn:aws:iam::210987654321:user/devenv"
}
```

## Build a container image<a name="applications-deploy-build"></a>

Your application code is packaged in a Docker container image, which includes the application code and libraries that you install in your Dockerfile\. Use the AWS Panorama Application CLI `build-container` command to build a Docker image and export a filesystem image\.

```
my-app$ panorama-cli build-container --container-asset-name code_asset --package-path packages/210987654321-SAMPLE_CODE-1.0
{
    "name": "code_asset",
    "implementations": [
        {
            "type": "container",
            "assetUri": "5fa5xmplbc8c16bf8182a5cb97d626767868d3f4d9958a4e49830e1551d227c5.tar.gz",
            "descriptorUri": "1872xmpl129481ed053c52e66d6af8b030f9eb69b1168a29012f01c7034d7a8f.json"
        }
    ]
}
Container asset for the package has been succesfully built at assets/5fa5xmplbc8c16bf8182a5cb97d626767868d3f4d9958a4e49830e1551d227c5.tar.gz
```

This command creates a Docker image named `code_asset` and exports a filesystem to a `.tar.gz` archive in the `assets` folder\. The CLI pulls the application base image from Amazon Elastic Container Registry \(Amazon ECR\), as specified in the application's Dockerfile\.

In addition to the container archive, the CLI creates an asset for the package descriptor \(`descriptor.json`\)\. Both files are renamed with a unique identifier that reflects a hash of the original file\. The AWS Panorama Application CLI also adds a block to the package manifest that records the names of the two assets\. These names are used by the appliance during the deployment process\.

**Example [packages/123456789012\-SAMPLE\_CODE\-1\.0/package\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/package.json) – with asset block**  

```
{
    "nodePackage": {
        "envelopeVersion": "2021-01-01",
        "name": "SAMPLE_CODE",
        "version": "1.0",
        "description": "Computer vision application code.",
        "assets": [
            {
                "name": "code_asset",
                "implementations": [
                    {
                        "type": "container",
                        "assetUri": "5fa5xmplbc8c16bf8182a5cb97d626767868d3f4d9958a4e49830e1551d227c5.tar.gz",
                        "descriptorUri": "1872xmpl129481ed053c52e66d6af8b030f9eb69b1168a29012f01c7034d7a8f.json"
                    }
                ]
            }
        ],
        "interfaces": [
            {
                "name": "interface",
                "category": "business_logic",
                "asset": "code_asset",
                "inputs": [
                    {
                        "name": "video_in",
                        "type": "media"
                    },
```

The name of the code asset, specified in the `build-container` command, must match the value of the `asset` field in the package manifest\. In the preceding example, both values are `code_asset`\.

## Import a model<a name="applications-deploy-model"></a>

Your application might have a model archive in its assets folder or that you download separately\. If you have a new model, an updated model, or updated model descriptor file, use the `add-raw-model` command to import it\.

```
my-app$ panorama-cli add-raw-model --model-asset-name model_asset \
      --model-local-path my-model.tar.gz \
      --descriptor-path packages/210987654321-SQUEEZENET_PYTORCH-1.0/descriptor.json \
      --packages-path packages/210987654321-SQUEEZENET_PYTORCH-1.0
```

If you just need to update the descriptor file, you can reuse the existing model in the assets directory\. You might need to update the descriptor file to configure features such as floating point precision mode\. For example, the following script shows how to do this with the sample app\.

**Example [util\-scripts/update\-model\-config\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/update-model-config.sh)**  

```
#!/bin/bash
set -eo pipefail
MODEL_ASSET=fd1axmplacc3350a5c2673adacffab06af54c3f14da6fe4a8be24cac687a386e
MODEL_PACKAGE=SQUEEZENET_PYTORCH
ACCOUNT_ID=$(ls packages | grep -Eo '[0-9]{12}' | head -1)
panorama-cli add-raw-model --model-asset-name model_asset --model-local-path assets/${MODEL_ASSET}.tar.gz --descriptor-path packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0/descriptor.json --packages-path packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0
cp packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0/package.json packages/${ACCOUNT_ID}-${MODEL_PACKAGE}-1.0/package.json.bup
```

Changes to the descriptor file in the model package directory are not applied until you reimport it with the CLI\. The CLI updates the model package manifest with the new asset names in\-place, similar to how it updates the manifest for the application code package when you rebuild a container\.

## Upload application assets<a name="applications-deploy-package"></a>

To upload and register the application's assets, which include the model archive, container filesystem archive, and their descriptor files, use the `package-application` command\.

```
my-app$ panorama-cli package-application
Uploading package SQUEEZENET_PYTORCH
Patch version for the package 5d3cxmplb7113faa1d130f97f619655d8ca12787c751851a0e155e50eb5e3e96
Deregistering previous patch version e845xmpl8ea0361eb345c313a8dded30294b3a46b486dc8e7c174ee7aab29362
Asset fd1axmplacc3350a5c2673adacffab06af54c3f14da6fe4a8be24cac687a386e.tar.gz already exists, ignoring upload
upload: assets/87fbxmpl6f18aeae4d1e3ff8bbc6147390feaf47d85b5da34f8374974ecc4aaf.json to s3://arn:aws:s3:us-east-2:212345678901:accesspoint/panorama-210987654321-6k75xmpl2jypelgzst7uux62ye/210987654321/nodePackages/SQUEEZENET_PYTORCH/binaries/87fbxmpl6f18aeae4d1e3ff8bbc6147390feaf47d85b5da34f8374974ecc4aaf.json
Called register package version for SQUEEZENET_PYTORCH with patch version 5d3cxmplb7113faa1d130f97f619655d8ca12787c751851a0e155e50eb5e3e96
...
```

If there are no changes to an asset file or the package manifest, the CLI skips it\.

```
Uploading package SAMPLE_CODE
Patch Version ca91xmplca526fe3f07821fb0c514f70ed0c444f34cb9bd3a20e153730b35d70 already registered, ignoring upload
Register patch version complete for SQUEEZENET_PYTORCH with patch version 5d3cxmplb7113faa1d130f97f619655d8ca12787c751851a0e155e50eb5e3e96
Register patch version complete for SAMPLE_CODE with patch version ca91xmplca526fe3f07821fb0c514f70ed0c444f34cb9bd3a20e153730b35d70
All packages uploaded and registered successfully
```

The CLI uploads the assets for each package to an Amazon S3 access point that is specific to your account\. AWS Panorama manages the access point for you, and provides information about it through the [DescribePackage](https://docs.aws.amazon.com/panorama/latest/api/API_DescribePackage.html) API\. The CLI uploads the assets for each package to the location provided for that package, and registers them with the AWS Panorama service with the configuration described by the package manifest\.

## Deploy an application with the AWS Panorama console<a name="applications-manage-deploy"></a>

You can deploy an application with the AWS Panorama console\. During the deployment process, you choose which camera streams to pass to the application code, and configure options provided by the application's developer\.

**To deploy an application**

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose **Deploy application**\.

1. Paste the contents of the application manifest, `graph.json`, into the text editor\. Choose **Next**\.

1. Enter a name and descroption\.

1. Choose **Proceed to deploy**\.

1. Choose **Begin deployment**\.

1. If your application [uses a role](permissions-application.md), choose it from the drop\-down menu\. Choose **Next**\.

1. Choose **Select device**, and then choose your appliance\. Choose **Next**\.

1. On the **Select data sources** step, choose **View input\(s\)**, and add your camera stream as a data source\. Choose **Next**\.

1. On the **Configure** step, configure any application\-specific settings defined by the developer\. Choose **Next**\.

1. Choose **Deploy**, and then choose **Done**\.

1. In the list of deployed applications, choose the application to monitor its status\.

The deployment process takes 15\-20 minutes\. The appliance's output can be blank for an extended period while the application starts\. If you encounter an error, see [Troubleshooting](panorama-troubleshooting.md)\.

## Automate application deployment<a name="applications-deploy-automate"></a>

You can automate the application deployment process with the [CreateApplicationInstance](https://docs.aws.amazon.com/panorama/latest/api/API_CreateApplicationInstance.html) API\. The API takes two configuration files as input\. The application manifest specifies the packages used and their relationships\. The second file is an overrides file that specifies deploy\-time overrides of values in the application manifest\. Using an overrides file lets you use the same application manifest to deploy the application with different camera streams, and configure other application\-specific settings\.

For more information, and example scripts for each of the steps in this topic, see [Automate application deployment](api-deploy.md)\.