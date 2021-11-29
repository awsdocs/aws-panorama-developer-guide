# Setting up a development environment in Windows<a name="applications-devenvwindows"></a>

To build a AWS Panorama application, you use Docker, command\-line tools, and Python\. In Windows, you can set up a development environment by using Docker Desktop with Windows Subsystem for Linux and Ubuntu\. This tutorial walks you through the setup process for a development environment that has been tested with AWS Panorama tools and sample applications\.

**Topics**
+ [Prerequisites](#applications-devenvwindows-prerequisites)
+ [Install WSL 2 and Ubuntu](#applications-devenvwindows-wsl2)
+ [Install Docker](#applications-devenvwindows-docker)
+ [Configure Ubuntu](#applications-devenvwindows-ubuntu)
+ [Next steps](#applications-devenvwindows-nextsteps)

## Prerequisites<a name="applications-devenvwindows-prerequisites"></a>

To follow this tutorial, you need a version of Windows that supports Windows Subsystem for Linux 2 \(WSL 2\)\.

****
+ Windows 10 version 1903 and higher \(Build 18362 and higher\) or Windows 11
+ Windows features
  + Windows Subsystem for Linux
  + Hyper\-V
  + Virtual machine platform

This tutorial was developed with the following software versions\.

****
+ Ubuntu 20\.04
+ Python 3\.8\.5
+ Docker 20\.10\.8

## Install WSL 2 and Ubuntu<a name="applications-devenvwindows-wsl2"></a>

If you have Windows 10 version 2004 and higher \(Build 19041 and higher\), you can install WSL 2 and Ubuntu 20\.04 with the following PowerShell command\.

```
> wsl --install -d Ubuntu-20.04
```

For older Windows version, follow the instructions in the WSL 2 documentation: [Manual installation steps for older versions](https://docs.microsoft.com/en-us/windows/wsl/install-manual)

## Install Docker<a name="applications-devenvwindows-docker"></a>

To install Docker Desktop, download and run the installer package from [hub\.docker\.com](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)\. If you encounter issues, follow the instructions on the Docker website: [Docker Desktop WSL 2 backend](https://docs.docker.com/desktop/windows/wsl/)\.

Run Docker Desktop and follow the first\-run tutorial to build an example container\.

**Note**  
Docker Desktop only enables Docker in the default distribution\. If you have other Linux distributions installed prior to running this tutorial, enable Docker in the newly installed Ubuntu distribution in the Docker Desktop settings menu under **Resources**, **WSL integration**\.

## Configure Ubuntu<a name="applications-devenvwindows-ubuntu"></a>

You can now run Docker commands in your Ubuntu virtual machine\. To open a command\-line terminal, run the distribution from the start menu\. The first time you run it, you configure a username and password that you can use to run administrator commands\.

To complete configuration of your development environment, update the virtual machine's software and install tools\.

**To configure the virtual machine**

1. Update the software that comes with Ubuntu\.

   ```
   $ sudo apt update && sudo apt upgrade -y && sudo apt autoremove
   ```

1. Install development tools with apt\.

   ```
   $ sudo apt install unzip python3-pip
   ```

1. Install Python libraries with pip\.

   ```
   $ pip3 install awscli panoramacli
   ```

1. Open a new terminal, and then run `aws configure` to configure the AWS CLI\.

   ```
   $ aws configure
   ```

   If you don't have access keys, you can generate them in the [IAM console](https://console.aws.amazon.com/iamv2/home?#/users)\.

Finally, download and import the sample application\.

**To get the sample application**

1. Download and extract the sample application\.

   ```
   $ wget https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v1.0-ga/aws-panorama-sample.zip
   $ unzip aws-panorama-sample.zip
   $ cd aws-panorama-sample
   ```

1. Run the included scripts to test compilation, build the application container, and upload packages to AWS Panorama\.

   ```
   aws-panorama-sample$ ./0-test-compile.sh
   aws-panorama-sample$ ./1-create-role.sh
   aws-panorama-sample$ ./2-import-app.sh
   aws-panorama-sample$ ./3-build-container.sh
   aws-panorama-sample$ ./4-package-app.sh
   ```

The AWS Panorama Application CLI uploads packages and registers them with the AWS Panorama service\. You can now [deploy the sample app](gettingstarted-deploy.md#gettingstarted-deploy-deploy) with the AWS Panorama console\.

## Next steps<a name="applications-devenvwindows-nextsteps"></a>

To explore and edit the project files, you can use File Explorer or an integrated development environment \(IDE\) that supports WSL\.

To access the virtual machine's file system, open File explorer and enter `\\wsl$` in the navigation bar\. This directory contains a link to the virtual machine's file system \(`Ubuntu-20.04`\) and file systems for Docker's data\. Under `Ubuntu-20.04`, your user directory is at `home\username`\.

**Note**  
To access files in your Windows installation from within Ubuntu, navigate to the `/mnt/c` directory\. For example, you can list files in your downloads directory by running `ls /mnt/c/Users/windows-username/Downloads`\.

With Visual Studio Code, you can edit application code in your development environment and run commands with an integrated terminal\. To install Visual Studio Code, visit [code\.visualstudio\.com](https://code.visualstudio.com/)\. After installation, add the [Remote WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension\.

Windows terminal is an alternative to the standard Ubuntu terminal that you’ve been running commands in\. It supports multiple tabs and can run PowerShell, Command Prompt, and terminals for any other variety of Linux that you install\. It supports copy and paste with  Ctrl C  and  Ctrl V , clickable URLs, and other useful improvements\. To install Windows Terminal, visit [microsoft\.com](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)\.