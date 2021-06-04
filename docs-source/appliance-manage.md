# Managing an AWS Panorama Appliance<a name="appliance-manage"></a>

You use the AWS Panorama console to configure, upgrade or deregister the AWS Panorama Appliance\.

To set up an appliance, follow the instructions in the [getting started tutorial](gettingstarted-setup.md)\. The setup process creates the resources in AWS Panorama that track your appliance and coordinate updates and deployments\.

**Topics**
+ [Update the appliance software](#appliance-manage-software)
+ [Deregister an appliance](#appliance-manage-delete)

## Update the appliance software<a name="appliance-manage-software"></a>

You view and deploy software updates for the AWS Panorama Appliance in the AWS Panorama console\. Updates can be required or optional\. When a required update is available, the console prompts you to apply it\. You can apply optional updates on the appliance **Settings** page\.

**Important**  
When you update the appliance software, all data on the device is overwritten except for the contents of the `/data` directory\. This directory includes your application data and logs\. You can also use `/data` to store scripts and other files\. For more information, see [The AWS Panorama Appliance Developer Kit](appliance-devkit.md)\.

**To update the appliance software**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose an appliance\.

1. Choose **Settings**

1. Under **System software**, choose **Install version**\.

## Deregister an appliance<a name="appliance-manage-delete"></a>

If you are done working with the AWS Panorama Appliance, you can use the AWS Panorama console to deregister it and delete the associated AWS IoT and AWS IoT Greengrass resources\.

When you delete an appliance from the AWS Panorama service, data on the appliance is not deleted automatically\. This data includes applications, camera information, the appliance certificate, network configuration, and logs\. You can remove [applications](appliance-applications.md) and [cameras](appliance-cameras.md#appliance-cameras-remove) from the device prior to deregistering it, or reset the device to its factory state\.

**To delete an appliance**

1. Open the AWS Panorama console [Appliances page](https://console.aws.amazon.com/panorama/home#appliances)\.

1. Choose the appliance\.

1. Choose **Delete**\.

1. Enter the appliance's name and choose **Delete**\.

To fully reset the device and delete all data, press both the power button and the reset button for over 5 seconds\. For more information, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.