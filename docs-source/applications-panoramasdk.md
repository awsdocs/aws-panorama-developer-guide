# The AWS Panorama Application SDK<a name="applications-panoramasdk"></a>

The AWS Panorama Application SDK is a Python library for developing AWS Panorama applications\. In your [application code](applications-code.md), you use the AWS Panorama Application SDK to load a computer vision model, run inference, and output video to a monitor\.

**Note**  
To ensure that you have access to the latest functionality of the AWS Panorama Application SDK, [upgrade the appliance software](appliance-manage.md#appliance-manage-software)\.

To interact with the AWS Panorama Application SDK\., you can connect to the AWS Panorama Appliance Developer Kit with SSH\. With a Python interpreter, you can load the AWS Panorama Application SDK and verify its behavior\.

```
$ python3
Python 3.7.5

>>> import panoramasdk
>>> help(panoramasdk)

    CLASSES
        builtins.list(builtins.object)
            port
        builtins.object
            base
            batch
            batch_set
    ...
```

For an introduction to using the AWS Panorama Appliance Developer Kit for development, see [Using the developer kit](gettingstarted-devkit.md)\.

For details about the classes that the application SDK defines and their methods, see [Application SDK reference](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/resources/applicationsdk-reference.md)\.