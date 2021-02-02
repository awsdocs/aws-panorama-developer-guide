# Troubleshooting<a name="panorama-troubleshooting"></a>

The following topics provide troubleshooting advice for errors and issues that you might encounter when using the AWS Panorama console, appliance, or SDK\. If you find an issue that is not listed here, you can use the **Provide feedback** button on this page to report it\.

You can find logs for your appliance in [the Amazon CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\. The appliance uploads logs from your application code, the appliance software, and AWS IoT processes as they are generated\. For more information, see [Viewing AWS Panorama event logs in CloudWatch Logs](monitoring-logging.md)\.

For more troubleshooting advice and answers to common support questions, visit the [AWS Knowledge Center](https://aws.amazon.com/premiumsupport/knowledge-center/)\.

## Application configuration<a name="troubleshooting-application"></a>

**Error:** *Unable to parse model configuration \.\.\. parseFile\(1145\) unable to open file*

The name of the model in AWS Panorama must match the name of the model parameter in your application code\. You refer to this name when you load a model with the `panoramasdk` module\.

## Appliance configuration<a name="troubleshooting-appliance"></a>

**Error:** *Resource temporarily unavailable* \(SSH\)

Check the network connection to the appliance\. A VPN client or firewall software can block connections\. If you reboot the AWS Panorama Appliance Developer Kit without the USB drive that contains the configuration archive, SSH is deactivated\.

**Issue:** *The appliance shows a blank screen during boot up\.*

After completing the initial boot sequence, which takes about one minute, the appliance shows a blank screen for a minute or more while it loads your model and starts your application\. Also, the appliance does not output video if you connect a display after it turns on\.

**Issue:** *The appliance doesn't respond when I hold the power button down to turn it off\.*

The appliance takes up to 10 seconds to shut down safely\. You need to hold the power button down for only 1 second to start the shutdown sequence\. For a complete list of button operations, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.

**Issue:** *I need to generate a new configuration archive to change settings or replace a lost certificate\.*

AWS Panorama does not store the device certificate or network configuration after you download it\. If you still have the archive and need to modify the network configuration, you can extract the `network.json` file, modify it, and update the archive\. If you don't have the archive, you can delete the appliance using the AWS Panorama console and create a new one with a new configuration bundle\.

## Camera configuration<a name="troubleshooting-camera"></a>

**Error:** *No camera has been found in the subnet\. Please verify that there is at least one camera in the subnet*

Automatic camera discovery uses [ONVIF profile S](https://www.onvif.org/conformant-products/) to search for camera streams on the appliance's local network\. If your camera does not support ONVIF or if automatic discovery doesn't work for some other reason, you can connect to a stream manually by entering the camera's IP address and RTSP stream URL\. For example: `rtsp://10.0.0.99/live/mpeg4`\. The path part of the URL varies depending on your camera\.

**Error:** *Failed to set up the "video/H264" subsession: 461 Unsupported transport*

**Error:** *Bit stream out of bounds\.*

**Error:** *initNal\(63\) Error encountered while processing NAL\.*

If you can connect the appliance to the camera in the AWS Panorama console, but errors such as these appear in the appliance logs, there may be an issue with the camera or the appliance software\. Verify that your camera supports H\.264 streams and is configured to use H\.264 if multiple codecs are available\.

Use the **Provide feedback** link on this page to send us the camera model and error\. For a list of cameras that have been tested for compatibility with the AWS Panorama Appliance, see [Supported cameras](gettingstarted-compatibility.md#gettingstarted-compatibility-cameras)\.