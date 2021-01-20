# AWS Panorama sample application

The project source includes function code and supporting resources:

- `function` - A Python function.
- `template.yml` - An AWS CloudFormation template that creates an application.
- `1-create-bucket.sh`, `2-build-layer.sh`, etc. - Shell scripts that use the AWS CLI to deploy and manage the application.

Use the following instructions to deploy the sample application.

# Requirements
- [Python 3.7](https://www.python.org/downloads/)
- The Bash shell. For Linux and macOS, this is included by default. In Windows 10, you can install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to get a Windows-integrated version of Ubuntu and Bash.
- [The AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) v1.17 or newer.

# Setup
Download or clone this repository.

    $ git clone https://github.com/awsdocs/aws-panorama-developer-guide.git
    $ cd aws-panorama-developer-guide/sample-apps/aws-panorama-sample

To create a new bucket for deployment artifacts, run `1-create-bucket.sh`.

    aws-panorama-sample$ ./1-create-bucket.sh
    make_bucket: aws-panorama-artifacts-a5e491dbb5b22e0d

Download the sample model that's attached to this repo.

    aws-panorama-sample$ wget https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v0.1-preview/ssd_512_resnet50_v1_voc.tar.gz

# Deploy
To deploy the application, run `2-deploy.sh`.

    aws-panorama-sample$ ./2-deploy.sh
    Successfully packaged artifacts and wrote output template to file out.yml.
    Waiting for changeset to be created..
    Waiting for stack create/update to complete
    Successfully created/updated stack - aws-panorama-sample

This script uses AWS CloudFormation to deploy the Lambda functions and an IAM role. If the AWS CloudFormation stack that contains the resources already exists, the script updates it with any changes to the template or function code.

# Upload model

If you haven't already, download the sample application's [model](https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v0.1-preview/ssd_512_resnet50_v1_voc.tar.gz) and save it in the project directory.

To upload the model to your S3 bucket, run `3-upload-model.sh`.

    aws-panorama-sample$ ./3-upload-model.sh

# Configure
To get configuration values, run `4-get-configuration.sh`.

    aws-panorama-sample$ ./4-get-configuration.sh
    FUNCTION VERSION ARN
    arn:aws:lambda:us-east-1:011685312445:function:aws-panorama-sample-function-WV4XS9NGCND7:1
    MODEL NAME
    aws-panorama-sample-model
    MODEL OBJECT URI
    s3://aws-panorama-artifacts-672b1549d86aad55/ssd_512_resnet50_v1_voc.tar.gz

You can use these values to configure a Panorama application in [the Panorama console](https://console.aws.amazon.com/panorama).

# Cleanup
To delete the application stack and bucket, run `5-cleanup.sh`.

    aws-panorama-sample$ ./5-cleanup.sh
