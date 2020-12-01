# AWS Panorama Appliance buttons and lights<a name="appliance-buttons"></a>

The AWS Panorama Appliance has two LED lights above the power button that indicate the device status and network connectivity\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/appliance-leds.png)

The LEDs change color and blink to indicate status\. A slow blink is once every three seconds\. A fast blink is once per second\.

**Status LED states**
+ **Fast blinking green** – The appliance is booting up\.
+ **Solid green** – The appliance is operating normally\.
+ **Slow blinking blue** – The appliance is copying configuration files and attempting to register with AWS IoT Greengrass\.
+ **Fast blinking red** – The appliance encountered an error during start up or is overheated\.
+ **Slow blinking orange** – The appliance is restoring the latest software image\.
+ **Fast blinking orange** – The appliance is restoring the factory software image

To reset the device, use the following button combinations\. A short press is 1 second\. A long press is 5 seconds\.

**Reset operations**
+ **Short press power** – Shut down the appliance\.
+ **Short press reset** – Restore the latest software image\.
+ **Long press reset** – Restore the factory software image\.
+ **Short press power and reset** – Start the provisioning sequence\. Copy files from an attached USB drive and register with AWS IoT Greengrass\.
+ **Long press power and reset** – Restore the factory software image and erase all user data\. **Delete configuration files, certificates and applications**\.

The network LED has the following states:

****
+ **Solid green** – An Ethernet cable is connected\.
+ **Blinking green** – The appliance is communicating over the network\.
+ **Solid red** – An Ethernet cable is not connected\.
+ **Solid blue** – An Ethernet cable is not connected, but WiFi is enabled\.