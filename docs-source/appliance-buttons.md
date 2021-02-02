# AWS Panorama Appliance buttons and lights<a name="appliance-buttons"></a>

The AWS Panorama Appliance has two LED lights above the power button that indicate the device status and network connectivity\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/appliance-leds.png)

The LEDs change color and blink to indicate status\. A slow blink is once every three seconds\. A fast blink is once per second\.

**Status LED states**
+ **Fast blinking green** – The appliance is booting up\.
+ **Solid green** – The appliance is operating normally\.
+ **Slow blinking blue** – The appliance is copying configuration files and attempting to register with AWS IoT Greengrass\.
+ **Fast blinking red** – The appliance encountered an error during startup or is overheated\.
+ **Slow blinking orange** – The appliance is restoring the latest software image\.
+ **Fast blinking orange** – The appliance is restoring the factory software image\.

To reset the device, use the following button combinations\. A short press is 1 second\. A long press is 5 seconds\. For operations that require multiple buttons, press and hold both buttons simultaneously\.

**Reset operations**
+ **To shut down the appliance** – Short press power\. Starts a shutdown sequence that takes about 10 seconds\.
+ **To restore the latest software image** – Short press reset\.
+ **To restore the factory software image** – Long press reset\.
+ **To restore the factory software image and delete all configuration files and applications** – Long press power and reset\.

The network LED has the following states:

**Network LED states**
+ **Solid green** – An Ethernet cable is connected\.
+ **Blinking green** – The appliance is communicating over the network\.
+ **Solid red** – An Ethernet cable is not connected\.
+ **Solid blue** – An Ethernet cable is not connected, but Wi\-Fi is enabled\.