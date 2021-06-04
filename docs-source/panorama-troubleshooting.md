# Troubleshooting<a name="panorama-troubleshooting"></a>

The following topics provide troubleshooting advice for errors and issues that you might encounter when using the AWS Panorama console, appliance, or SDK\. If you find an issue that is not listed here, use the **Provide feedback** button on this page to report it\.

You can find logs for your appliance in [the Amazon CloudWatch Logs console](https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups)\. The appliance uploads logs from your application code, the appliance software, and AWS IoT processes as they are generated\. For more information, see [Viewing AWS Panorama event logs in CloudWatch Logs](monitoring-logging.md)\.

For more troubleshooting advice and answers to common support questions, visit the [AWS Knowledge Center](https://aws.amazon.com/premiumsupport/knowledge-center/)\.

## Application configuration<a name="troubleshooting-application"></a>

**Error:** *Unable to parse model configuration \.\.\. parseFile\(1145\) unable to open file*

The name of the model in AWS Panorama must match the name of the model parameter in your application code\. You refer to this name when you load a model with the `panoramasdk` module\.

**Error:** *Failed to initialize Lambda runtime due to exception: initialize\(108\) Node enable signal is not set, terminating*

The software that runs your application code waits for a signal from another process before loading the Lambda function handler\. If your code returns an error, the application node is deactivated, causing this error to appear repeatedly in the application log\. Check the log from when the application deployment completed to find the original error that caused the node to be deactivated\. You can also search for the text *Failed to call Lambda entry method* which appears when your code throws an exception\.

## Appliance configuration<a name="troubleshooting-appliance"></a>

**Error:** *Resource temporarily unavailable* \(SSH\)

Check the network connection to the appliance\. A VPN client or firewall software can block connections\.

**Issue:** *The appliance shows a blank screen during boot up\.*

After completing the initial boot sequence, which takes about one minute, the appliance shows a blank screen for a minute or more while it loads your model and starts your application\. Also, the appliance does not output video if you connect a display after it turns on\.

**Issue:** *The appliance doesn't respond when I hold the power button down to turn it off\.*

The appliance takes up to 10 seconds to shut down safely\. You need to hold the power button down for only 1 second to start the shutdown sequence\. For a complete list of button operations, see [AWS Panorama Appliance buttons and lights](appliance-buttons.md)\.

**Issue:** *I need to generate a new configuration archive to change settings or replace a lost certificate\.*

AWS Panorama does not store the device certificate or network configuration after you download it\. If you still have the archive and need to modify the network configuration, you can extract the `network.json` file, modify it, and update the archive\. If you don't have the archive, you can delete the appliance using the AWS Panorama console and create a new one with a new configuration archive\.

## Camera configuration<a name="troubleshooting-camera"></a>

**Error:** *No camera has been found in the subnet\. Please verify that there is at least one camera in the subnet*

Automatic camera discovery uses [ONVIF profile S](https://www.onvif.org/conformant-products/) to search for camera streams on the appliance's local network\. If your camera does not support ONVIF or if automatic discovery doesn't work for some other reason, you can connect to a stream manually by entering the camera's IP address and RTSP stream URL\. For example: `rtsp://10.0.0.99/live/mpeg4`\. The path part of the URL varies depending on your camera\.

**Error:** *Failed to set up the "video/H264" subsession: 461 Unsupported transport*

**Error:** *Bit stream out of bounds\.*

**Error:** *initNal\(63\) Error encountered while processing NAL\.*

If you can connect the appliance to the camera in the AWS Panorama console, but errors such as these appear in the appliance logs, there may be an issue with the camera or the appliance software\. Verify that your camera supports H\.264 streams and is configured to use H\.264 if multiple codecs are available\.

Use the **Provide feedback** link on this page to send us the camera model and error\. For a list of cameras that have been tested for compatibility with the AWS Panorama Appliance, see [Supported cameras](gettingstarted-compatibility.md#gettingstarted-compatibility-cameras)\.

## Model compatibility<a name="troubleshooting-model"></a>

**Error:** *ClientError: OperatorNotImplemented:\('Operator *Model* is not supported for frontend *Keras*\.*

Your model's architecture is not supported\. When you deploy a model, AWS Panorama uses SageMaker Neo to compile it to run on the AWS Panorama Appliance\. SageMaker Neo supports [a subset of layer types for each model framework](https://aws.amazon.com/releasenotes/sagemaker-neo-supported-frameworks-and-operators/)\.

For more information, see [Supported models](gettingstarted-compatibility.md#gettingstarted-compatibility-models)\.

**Error:** *ClientError: InputConfiguration: No valid TensorFlow model found in input files\. Please make sure the framework you select is correct\.*

For TensorFlow models, you must use the [SavedModel](https://www.tensorflow.org/guide/saved_model) format\. If you create a TensorFlow model with Keras, call `model.save` with a directory name, not a filename that has a `.h5` or `.keras` extension\. Including these extensions creates an H5\-format model file, which is not supported\.

**Error:** *ClientError: InputConfiguration: TVM cannot convert Tensorflow model\. Please make sure the framework you selected is correct\.*

This error can occur if you specify the input shape of the model incorrectly\. To find the input shape, check the configuration of your input layer\. For example, in Keras, you can use the `summary` method on the model, or `get_config` on the layer\.

In the following examples, the input name is `input_1` and the input shape is `1,224,224,3`\. The first value is the batch size, which is not hard\-coded in the model\. This is followed by the image width and height, and the number of color channels\. In some models, the number of channels comes before the height and width\.

**Example Model summary**  

```
Model: "mobilenetv2_1.00_224"
__________________________________________________________________________________________________
Layer (type)                    Output Shape         Param #     Connected to                     
==================================================================================================
input_1 (InputLayer)            [(None, 224, 224, 3) 0
```

**Example Layer configuration**  

```
{'batch_input_shape': (None, 224, 224, 3),
 'dtype': 'float32',
 'sparse': False,
 'ragged': False,
 'name': 'input_1'}
```