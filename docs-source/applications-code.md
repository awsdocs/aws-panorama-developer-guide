# Authoring application code<a name="applications-code"></a>

In your application code, you use the AWS Panorama Application SDK to load the model, run inference, and output results\. The AWS Panorama Application SDK is a Python library that is available in the runtime environment on the AWS Panorama Appliance\. The SDK defines a base class for applications and provides methods for loading a model and using it to process images\.

AWS Panorama use AWS Lambda and AWS IoT Greengrass to manage and deploy application code\. In Lambda, you [create a Python 3\.7 function](gettingstarted-deploy.md) and publish a version that stores your application's code\. When you deploy an application, AWS Panorama uses AWS IoT Greengrass to deploy the code and the application's model to the AWS Panorama Appliance\. 

In your application code, you can also use the AWS SDK for Python \(Boto3\) and common machine learning and computer vision libraries like NumPy and OpenCV\. With the SDK for Python \(Boto3\), you can use AWS services to store results or perform additional processing\. For more information, see [Calling AWS services from your application code](applications-awssdk.md)\.

**Topics**
+ [Using the base class](#applications-code-base)
+ [Defining inputs and outputs](#applications-code-parameters)
+ [Loading a model](#applications-code-model)
+ [Processing frames](#applications-code-frames)

## Using the base class<a name="applications-code-base"></a>

To create an application class, declare `panoramasdk.base` as the parent class and define the following methods:

****
+ `interface` – Returns a dictionary that defines the class's parameters, input type, and output type
+ `init` – Creates resources that are reused, such as the application's model and AWS SDK clients
+ `entry` – Processes a frame of video from one or more camera streams
+ `main` – Instantiates the class and calls `run()` on it

The following code shows the basic outline of an application class\.

**Example my\_application\.py – Class methods**  

```
import panoramasdk

class my_application(panoramasdk.base):

  def interface(self):
    ...

  def init(self, parameters, inputs, outputs):
    ...

  def entry(self, inputs, outputs):
    ...

def main():
  my_application().run()

main()
```

The `run` method is part of the parent class\. It tells the AWS Panorama Application SDK that the application is ready to process video streams\.

## Defining inputs and outputs<a name="applications-code-parameters"></a>

The `interface` method returns an object that defines the application's parameters, inputs, and outputs\.

```
  def interface(self):
    return {
      "parameters":
        (
          ("model", "model_name", "Name of the model in AWS Panorama", "aws-panorama-sample-model"),
        ),
      "inputs":
        (
          ("media[]", "video_in", "Camera input stream"),
        ),
      "outputs":
        (
          ("media[video_in]", "video_out", "Camera output stream"),
        )
    }
```

The `media` array under `inputs` represents input from cameras connected to the appliance\. The application SDK fills this array with frames of video \(one for each stream\) and passes it to the [entry method](#applications-code-frames)\. Similarly, the `outputs` object provides a place to write an output image after processing the input\.

The `parameters` object defines the application's runtime configuration\. In the preceding example, the `model_name` parameter has type `model` and its value is `aws-panorama-sample-model`\. The value of `model_name` is accessible by referencing `parameters.model_name`\. To avoid hard\-coding names and numbers in your application logic, define them in the interface object\.

Parameters can have the following types\.

****
+ `media` – A frame of video
+ `model` – A computer vision model
+ `rect` – A rectangle of \(x0, y0, x1, y1\)
+ `string` – A string
+ `uint32` – A 4\-byte, unsigned integer
+ `int` – An integer
+ `float` – A floating\-point value
+ `byte` – A byte
+ `bool` – `True` or `False`

## Loading a model<a name="applications-code-model"></a>

In the `init` method, load the application's model and create other reusable resources, such as AWS SDK clients\.

```
  def init(self, parameters, inputs, outputs):
    try:
      print("Loading model: " + parameters.model_name)
      self.model = panoramasdk.model()
      self.model.open(parameters.model_name, 1)
      return True
    except Exception as e:
      print("Exception: {}".format(e))
      return False
```

## Processing frames<a name="applications-code-frames"></a>

The `entry` method processes an array of frames from one or more video streams\. The input is an array of `media` objects that represent frames of video\. If the application is connected to one camera stream, `inputs.video_in` has only one object\.

The following example shows an application getting a frame from each attached camera stream, calling a local `preprocess` method to resize and normalize it, and processing the result with a model\.

```
  def entry(self, inputs, outputs):

    for i in range(len(inputs.video_in)):
      frame = inputs.video_in[i]
      frame.add_label('AWS Panorama', 0.8, 0.05)
      frame_image = frame.image

      # Prepare the image and run inference
      normalized_image = self.preprocess(frame_image)
      self.model.batch(0, normalized_image)
      self.model.flush()
      resultBatchSet = self.model.get_result()
      ...

      self.model.release_result(resultBatchSet)
      outputs.video_out[i] = frame

    return True
```