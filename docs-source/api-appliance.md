# Manage appliances with the AWS Panorama API<a name="api-appliance"></a>

You can automate appliance management tasks with the AWS Panorama API\.

## View devices<a name="api-appliance-view"></a>

To get a list of appliances with device IDs, use the [ListDevices](https://docs.aws.amazon.com/panorama/latest/api/API_ListDevices.html) API\.

```
$ aws panorama list-devices
    "Devices": [
        {
            "DeviceId": "device-4tafxmplhtmzabv5lsacba4ere",
            "Name": "my-appliance",
            "CreatedTime": 1652409973.613,
            "ProvisioningStatus": "SUCCEEDED",
            "LastUpdatedTime": 1652410973.052,
            "LeaseExpirationTime": 1652842940.0
        }
    ]
}
```

To get more details about an appliance, use the [DescribeDevice](https://docs.aws.amazon.com/panorama/latest/api/API_DescribeDevice.html) API\.

```
$ aws panorama describe-device --device-id device-4tafxmplhtmzabv5lsacba4ere
{
    "DeviceId": "device-4tafxmplhtmzabv5lsacba4ere",
    "Name": "my-appliance",
    "Arn": "arn:aws:panorama:us-west-2:123456789012:device/device-4tafxmplhtmzabv5lsacba4ere",
    "Type": "PANORAMA_APPLIANCE",
    "DeviceConnectionStatus": "ONLINE",
    "CreatedTime": 1648232043.421,
    "ProvisioningStatus": "SUCCEEDED",
    "LatestSoftware": "4.3.55",
    "CurrentSoftware": "4.3.45",
    "SerialNumber": "GFXMPL0013023708",
    "Tags": {},
    "CurrentNetworkingStatus": {
        "Ethernet0Status": {
            "IpAddress": "192.168.0.1/24",
            "ConnectionStatus": "CONNECTED",
            "HwAddress": "8C:XM:PL:60:C5:88"
        },
        "Ethernet1Status": {
            "IpAddress": "--",
            "ConnectionStatus": "NOT_CONNECTED",
            "HwAddress": "8C:XM:PL:60:C5:89"
        }
    },
    "LeaseExpirationTime": 1652746098.0
}
```

## Upgrade appliance software<a name="api-appliance-upgrade"></a>

If the `LatestSoftware` version is newer than the `CurrentSoftware`, you can upgrade the device\. Use the [CreateJobForDevices](https://docs.aws.amazon.com/panorama/latest/api/API_CreateJobForDevices.html) API to create an over\-the\-air \(OTA\) update job\.

```
$ aws panorama create-job-for-devices --device-ids device-4tafxmplhtmzabv5lsacba4ere \
  --device-job-config '{"OTAJobConfig": {"ImageVersion": "4.3.55"}}' --job-type OTA
{
    "Jobs": [
        {
            "JobId": "device-4tafxmplhtmzabv5lsacba4ere-0",
            "DeviceId": "device-4tafxmplhtmzabv5lsacba4ere"
        }
    ]
}
```

In a script, you can populate the image version field in the job configuration file with Bash string manipulation\.

**Example [check\-updates\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/check-updates.sh)**  

```
apply_update() {
    DEVICE_ID=$1
    NEW_VERSION=$2
    CONFIG='{"OTAJobConfig": {"ImageVersion": "NEW_VERSION"}}'
    CONFIG=${CONFIG/NEW_VERSION/$NEW_VERSION}
    aws panorama create-job-for-devices --device-ids ${DEVICE_ID} --device-job-config "${CONFIG}" --job-type OTA
}
```

The appliance downloads the specified software version and updates itself\. Watch the update's progress with the [DescribeDeviceJob](https://docs.aws.amazon.com/panorama/latest/api/API_DescribeDeviceJob.html) API\.

```
$ aws panorama describe-device-job --job-id device-4tafxmplhtmzabv5lsacba4ere-0
{
    "JobId": "device-4tafxmplhtmzabv5lsacba4ere-0",
    "DeviceId": "device-4tafxmplhtmzabv5lsacba4ere",
    "DeviceArn": "arn:aws:panorama:us-west-2:559823168634:device/device-4tafxmplhtmzabv5lsacba4ere",
    "DeviceName": "my-appliance",
    "DeviceType": "PANORAMA_APPLIANCE",
    "ImageVersion": "4.3.55",
    "Status": "REBOOTING",
    "CreatedTime": 1652410232.465
}
```

To get a list of all running jobs, use the [ListDevicesJobs](https://docs.aws.amazon.com/panorama/latest/api/API_ListDevicesJobs.html)\.

```
$ aws panorama list-devices-jobs
{
    "DeviceJobs": [
        {
            "DeviceName": "my-appliance",
            "DeviceId": "device-4tafxmplhtmzabv5lsacba4ere",
            "JobId": "device-4tafxmplhtmzabv5lsacba4ere-0",
            "CreatedTime": 1652410232.465
        }
    ]
}
```

For a sample script that checks for and applies updates, see [check\-updates\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/check-updates.sh) in this guide's GitHub repository\.

## Reboot appliances<a name="api-appliance-reboot"></a>

To reboot an appliance, use the [CreateJobForDevices](https://docs.aws.amazon.com/panorama/latest/api/API_CreateJobForDevices.html) API\.

```
$ aws panorama create-job-for-devices --device-ids device-4tafxmplhtmzabv5lsacba4ere --job-type REBOOT
{
    "Jobs": [
        {
            "JobId": "device-4tafxmplhtmzabv5lsacba4ere-0",
            "DeviceId": "device-4tafxmplhtmzabv5lsacba4ere"
        }
    ]
}
```

In a script, you can get a list of devices and choose one to reboot interactively\.

**Example [reboot\-device\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/reboot-device.sh) – usage**  

```
$ ./reboot-device.sh
Getting devices...
0: device-53amxmplyn3gmj72epzanacniy     my-se70-1
1: device-6talxmpl5mmik6qh5moba6jium     my-manh-24
Choose a device
1
Reboot device device-6talxmpl5mmik6qh5moba6jium? (y/n)y
{
    "Jobs": [
        {
            "DeviceId": "device-6talxmpl5mmik6qh5moba6jium",
            "JobId": "device-6talxmpl5mmik6qh5moba6jium-8"
        }
    ]
}
```