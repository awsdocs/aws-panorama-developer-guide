# Managing an AWS Panorama Appliance<a name="appliance-manage"></a>

You use the AWS Panorama console to configure, upgrade or deregister the AWS Panorama Appliance and other [compatible devices](gettingstarted-concepts.md#gettingstarted-concepts-devices)\.

To set up an appliance, follow the instructions in the [getting started tutorial](gettingstarted-setup.md)\. The setup process creates the resources in AWS Panorama that track your appliance and coordinate updates and deployments\.

To register an appliance with the AWS Panorama API, see [Automate device registration](api-provision.md)\.

**Topics**
+ [Update the appliance software](#appliance-manage-software)
+ [Deregister an appliance](#appliance-manage-delete)
+ [Reboot an appliance](#appliance-manage-reboot)
+ [Reset an appliance](#appliance-manage-reset)

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

**To delete an appliance**

1. Open the AWS Panorama console [Devices page](https://console.aws.amazon.com/panorama/home#devices)\.

1. Choose the appliance's name\.

1. Choose **Delete**\.

1. Enter the appliance's name and choose **Delete**\.

When you delete an appliance from the AWS Panorama service, data on the appliance is not deleted automatically\. A deregistered appliance can't connect to AWS services and can't be registered again until it is reset\.

## Reboot an appliance<a name="appliance-manage-reboot"></a>

You can reboot an appliance remotely\.

**To reboot an appliance**

1. Open the AWS Panorama console [Devices page](https://console.aws.amazon.com/panorama/home#devices)\.

1. Choose the appliance's name\.

1. Choose **Reboot**\.

The console sends a message to the appliance to reboot it\. To receive the signal, the appliance must be able to connect to AWS IoT\. To reboot an appliance with the AWS Panorama API, see [Reboot appliances](api-appliance.md#api-appliance-reboot)\.

## Reset an appliance<a name="appliance-manage-reset"></a>

To use an appliance in a different Region or with a different account, you must reset it and reprovision it with a new certificate\. Resetting the device applies the most recent required software version and deletes all account data\.

To start a reset operation, the appliance must be plugged in and powered down\. Press and hold both the power and reset buttons for five seconds\. When you release the buttons, the status light blinks orange\. Wait until the status light blinks green before provisioning or disconnecting the appliance\.

You can also reset the appliance software without deleting certificates from the device\. For more information, see [Power and reset buttons](appliance-buttons.md#appliance-buttons-reset)\.