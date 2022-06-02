# Managing an AWS Panorama Appliance<a name="appliance-manage"></a>

You use the AWS Panorama console to configure, upgrade or deregister the AWS Panorama Appliance and other [compatible devices](gettingstarted-concepts.md#gettingstarted-concepts-devices)\.

To set up an appliance, follow the instructions in the [getting started tutorial](gettingstarted-setup.md)\. The setup process creates the resources in AWS Panorama that track your appliance and coordinate updates and deployments\.

To register an appliance with the AWS Panorama API, see [Automate device registration](api-provision.md)\.

**Topics**
+ [Update the appliance software](#appliance-manage-software)
+ [Deregister an appliance](#appliance-manage-delete)

## Update the appliance software<a name="appliance-manage-software"></a>

You view and deploy software updates for the appliance in the AWS Panorama console\. Updates can be required or optional\. When a required update is available, the console prompts you to apply it\. You can apply optional updates on the appliance **Settings** page\.

**To update the appliance software**

1. Open the AWS Panorama console [Devices page](https://console.aws.amazon.com/panorama/home#devices)\.

1. Choose an appliance\.

1. Choose **Settings**

1. Under **System software**, choose **Install software update**\.  
![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/setup-upgrade.png)

1. Choose a new version and then choose **Install**\.

## Deregister an appliance<a name="appliance-manage-delete"></a>

If you are done working with an appliance, you can use the AWS Panorama console to deregister it and delete the associated AWS IoT resources\.

When you delete an appliance from the AWS Panorama service, data on the appliance is not deleted automatically\. This data includes applications, camera information, the appliance certificate, network configuration, and logs\. You can remove [applications](appliance-applications.md) from the device prior to deregistering it, or reset the device to its factory state\.

**To delete an appliance**

1. Open the AWS Panorama console [Devices page](https://console.aws.amazon.com/panorama/home#devices)\.

1. Choose the appliance\.

1. Choose **Delete**\.

1. Enter the appliance's name and choose **Delete**\.

To fully reset the device and delete all data, press both the power button and the reset button for over 5 seconds\. For more information, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.