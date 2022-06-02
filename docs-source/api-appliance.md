# Manage appliances<a name="api-appliance"></a>

You can automate appliance management tasks with the AWS Panorama API\. To get a list of appliances with device IDs, use the [ListDevices](https://docs.aws.amazon.com/panorama/latest/api/API_ListDevices.html) API\.

```
$ aws panorama list-devices
    "Devices": [
        {
            "DeviceId": "device-4taf3j43htmzabv5lsacba4ere",
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
$ aws panorama describe-device --device-id device-4taf3j43htmzabv5lsacba4ere
{
    "DeviceId": "device-4taf3j43htmzabv5lsacba4ere",
    "Name": "my-appliance",
    "Arn": "arn:aws:panorama:us-west-2:123456789012:device/device-4taf3j43htmzabv5lsacba4ere",
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

If the `LatestSoftware` version is newer than the `CurrentSoftware`, you can upgrade the device\. Use the [CreateJobForDevices](https://docs.aws.amazon.com/panorama/latest/api/API_CreateJobForDevices.html) API to create an over\-the\-air \(OTA\) update\.

```
$ aws panorama create-job-for-devices --device-ids device-4taf3j43htmzabv5lsacba4ere \
  --device-job-config '{"OTAJobConfig": {"ImageVersion": "4.3.55"}}' --job-type OTA
{
    "Jobs": [
        {
            "JobId": "device-4taf3j43htmzabv5lsacba4ere-0",
            "DeviceId": "device-4taf3j43htmzabv5lsacba4ere"
        }
    ]
}
```

The appliance downloads the specified software version and updates itself\. Watch the update's progress with the [DescribeDeviceJob](https://docs.aws.amazon.com/panorama/latest/api/API_DescribeDeviceJob.html) API\.

```
$ aws panorama describe-device-job --job-id device-4taf3j43htmzabv5lsacba4ere-0
{
    "JobId": "device-4taf3j43htmzabv5lsacba4ere-0",
    "DeviceId": "device-4taf3j43htmzabv5lsacba4ere",
    "DeviceArn": "arn:aws:panorama:us-west-2:559823168634:device/device-4taf3j43htmzabv5lsacba4ere",
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
            "DeviceId": "device-4taf3j43htmzabv5lsacba4ere",
            "JobId": "device-4taf3j43htmzabv5lsacba4ere-0",
            "CreatedTime": 1652410232.465
        }
    ]
}
```