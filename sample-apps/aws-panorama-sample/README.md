# Classification app

The project source includes Python code and supporting resources:

- `aws-panorama-sample.yml` - A template that creates an IAM role for the application.
- `01-create-role.sh`, etc. - Shell scripts that use the AWS CLI to deploy and manage the application.

Use the following instructions to deploy the sample application.

# Requirements

This project uses the following software.

- The Bash shell. For Linux and macOS, this is included by default. In Windows 10, you can install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to get a Windows-integrated version of Ubuntu and Bash.
- [The AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) v1.17 or newer.
- [jq](https://stedolan.github.io/jq/) to parse JSON responses from AWS services.
- [Python 3](https://www.python.org/downloads/)
- [The AWS Panorama application CLI](https://github.com/aws/aws-panorama-cli)

You can use `pip` to install the application CLI:

    $ pip install --upgrade panoramacli

# Setup

Download or clone this repository.

    $ git clone https://github.com/awsdocs/aws-panorama-developer-guide.git
    $ cd aws-panorama-developer-guide/sample-apps/aws-panorama-sample

To create a role that grants the application permission to upload metrics, run `1-create-role.sh`.

    aws-panorama-sample$ ./1-create-role.sh
    Waiting for changeset to be created..
    Waiting for stack create/update to complete
    Successfully created/updated stack - panorama-aws-panorama-sample

This script uses AWS CloudFormation to create AWS resources, which are defined in the template [aws-panorama-sample.yml](aws-panorama-sample.yml). If the CloudFormation stack that contains the resources already exists, the script updates it with any changes to the template or function code.

# Import application

To import the application, run `2-import-app.sh`.

    aws-panorama-sample$ ./2-import-app.sh
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    100 4566k  100 4566k    0     0  3673k      0  0:00:01  0:00:01 --:--:-- 3673k
    Sucessfully imported application

This script uses the application CLI to update source paths with your account ID, and downloads the sample model archive.

Next, open the `graphs/my-app/override.json` and replace the placeholder values with your camera and device information.

    {
        "nodeGraphOverrides": {
            "nodes": [
                {
                    "name": "camera_node_override",
                    "interface": "012345678901::exterior-north.exterior-north"
                },
                {
                    "name": "region_override",
                    "interface": "string",
                    "value": "us-west-2"
                },

# Build and deploy

Run the following scripts to build the application, upload it to Amazon S3, and deploy it to a device.

    ./3-build-container.sh
    ./4-package-app.sh
    ./5-deploy.sh

The first time you deploy, the `5-deploy.sh` script prompts you to choose a device. It stores the device ID and application instance ID in local files for subsequent deployments.

# Cleanup

To remove the sample application from your device, run, `8-delete-application.sh`.

    aws-panorama-sample$ ./8-delete-application.sh

To delete the application role, run `9-delete-role.sh`.

    aws-panorama-sample$ ./9-delete-role.sh