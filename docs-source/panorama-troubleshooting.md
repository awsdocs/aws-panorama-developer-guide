# Troubleshooting<a name="panorama-troubleshooting"></a>

The following topics provide troubleshooting advice for errors and issues that you might encounter when using the AWS Panorama console, appliance, or SDK\. If you find an issue that is not listed here, use the **Provide feedback** button on this page to report it\.

You can find logs for your appliance in [the Amazon CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\. The appliance uploads logs from your application code, the appliance software, and AWS IoT processes as they are generated\. For more information, see [Viewing AWS Panorama logs](monitoring-logging.md)\.

## Provisioning<a name="troubleshooting-provisioning"></a>

**Issue:** \(macOS\) *My computer doesn't recognize the included USB drive with a USB\-C adapter\.*

This can occur if you plug the USB drive into a USB\-C adapter that is already connected to your computer\. Try disconnecting the adapter and reconnecting it with the USB drive already attached\.

**Issue:** *Provisioning fails when I use my own USB drive\.*

**Issue:** *Provisioning fails when I use the appliance's USB 2\.0 port\.*

The AWS Panorama Appliance is compatible with USB flash memory devices between 1 and 32 GB, but not all are compatible\. Some issues have been observed when using the USB 2\.0 port for provisioning\. For consistent results, use the included USB drive with the USB 3\.0 port \(next to the HDMI port\)\.

## Appliance configuration<a name="troubleshooting-appliance"></a>

**Issue:** *The appliance shows a blank screen during boot up\.*

After completing the initial boot sequence, which takes about one minute, the appliance shows a blank screen for a minute or more while it loads your model and starts your application\. Also, the appliance does not output video if you connect a display after it turns on\.

**Issue:** *The appliance doesn't respond when I hold the power button down to turn it off\.*

The appliance takes up to 10 seconds to shut down safely\. You need to hold the power button down for only 1 second to start the shutdown sequence\. For a complete list of button operations, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.

**Issue:** *I need to generate a new configuration archive to change settings or replace a lost certificate\.*

AWS Panorama does not store the device certificate or network configuration after you download it, and you can't reuse configuration archives\. Delete the appliance using the AWS Panorama console and create a new one with a new configuration archive\.

## Application configuration<a name="troubleshooting-application"></a>

**Issue:** *When I run multiple applications, I can't control which uses the HDMI output\.*

When you deploy multiple applications that have output nodes, the application that started most recently uses the HDMI output\. If this application stops running, another application can use the output\. To give only one application access to the output, remove the output node and corresponding edge from the other application's [application manifest](applications-manifest.md) and redeploy\.

**Issue:** *Application output doesn't appear in logs*

[Configure a Python logger](monitoring-logging.md#monitoring-logging-configuration) to write log files to `/opt/aws/panorama/logs`\. These are captured in a log stream for the code container node\. Standard output and error streams are captured in a separate log stream called `console-output`\. If you use `print`, use the `flush=True` option to keep messages from getting stuck in the output buffer\.

**Error:** *You've reached the maximum number of versions for package SAMPLE\_CODE\. Deregister unused package versions and try again\.*

**Source:** AWS Panorama service

Each time you deploy a change to an application, you register a *patch version* that represents the package manifest and asset files for each package that it uses\. Use the [cleanup patches script](panorama-samples.md#samples-scripts) to deregister unused patch versions\.

## Camera streams<a name="troubleshooting-camera"></a>

**Error:** *liveMedia0: Failed to get SDP description: Connection to server failed: Connection timed out \(\-115\)*

**Source:** Camera node log

The appliance can't connect to the application's camera stream\. When this happens, the video output is blank or freezes on the last processed frame while the application waits for a frame of video from the AWS Panorama Application SDK\. The appliance software attempts to connect to the camera stream and logs timeout errors in the camera node log\. Verify that your camera stream URL is correct and that RTSP traffic is routable between the camera and appliance within your network\. For more information, see [Connecting the AWS Panorama Appliance to your network](appliance-network.md)\.

**Error:** *ERROR finalizeInterface\(35\) Camera credential fetching for port \[username\] failed*

**Source:** OCC log

The AWS Secrets Manager secret with the camera stream's credentials can't be found\. Delete the camera stream and recreate it\.