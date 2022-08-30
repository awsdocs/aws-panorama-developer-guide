# CloudFormation templates

To create a CloudFormation stack, use the `create-stack.sh` script with the template name.

    $ ./create-stack.sh application-role

If the template takes parameters, specify the parameters after the template name.

    $ ./create-stack.sh alarm-device notificationEmail=me@example.com deviceName=my-appliance deviceId=device-m3axxmpl2tirl6fvf67ast2iqm

To delete a stack, use the `delete-stack.sh` script.

    $ ./delete-stack.sh alarm-device

## alarm-application

Create an alarm that monitors an application for errors. If the application instance raises errors or stops running for 5 minutes, the alarm sends a notification email.

Name and ID parameters are both required. When you deploy a new version of the application, you must update the application ID.

**Parameters**
- `notificationEmail` - The email address that receives alarm notifications.
- `applicationName` - The name of the application to monitor.
- `applicationId` - The ID of the application instance to monitor.

## alarm-device

Create an alarm that monitors a device's connectivity. If the device stops sending metrics for 5 minutes, the alarm sends a notification email.

Name and ID parameters are both required.

**Parameters**
- `notificationEmail` - The email address that receives alarm notifications.
- `deviceName` - The name of the device to monitor.
- `deviceId` - The ID of the device to monitor.

## application-role

Create an application role. The role includes permission to send metrics to CloudWatch. Add permissions to the policy statement for other API operations that your application uses.

## vpc-appliance

Create a VPC with private subnet service access for the AWS Panorama Appliance. To connect the appliance to a VPC, use AWS Direct Connect or AWS Site-to-Site VPN.

## vpc-endpoint

Create a VPC with private subnet service access to the AWS Panorama service. Resources inside of the VPC can connect to AWS Panorama to monitor and manage AWS Panorama resources without connecting to the internet.