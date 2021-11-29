# Developing AWS Panorama applications<a name="gettingstarted-sample"></a>

You can use the sample application to learn about AWS Panorama application structure, and as a starting point for your own application\.

The following diagram shows the major components of the application running on an AWS Panorama Appliance\. The application code uses the AWS Panorama Application SDK to get images and interact with the model, which it doesn't have direct access to\. The application outputs video to a connected display but does not send image data outside of your local network\.

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/sample-app.png)

In this example, the application uses the AWS Panorama Application SDK to get frames of video from a camera, preprocess the video data, and send the data to a computer vision model that detects objects\. The application displays the result on an HDMI display connected to the appliance\.

**Topics**
+ [The application manifest](#gettingstarted-sample-manifest)
+ [Building with the sample application](#gettingstarted-sample-adapting)
+ [Changing the computer vision model](#gettingstarted-sample-model)
+ [Preprocessing images](#gettingstarted-sample-preprocessing)
+ [Uploading metrics with the SDK for Python](#gettingstarted-sample-metrics)
+ [Next steps](#gettingstarted-sample-nextsteps)

## The application manifest<a name="gettingstarted-sample-manifest"></a>

The application manifest is a file named `graph.json` in the `graphs` folder\. The manifest defines the application's components, which are packages, nodes, and edges\.

Packages are code, configuration, and binary files for application code, models, cameras, and displays\. The sample application uses 4 packages:

**Example `graphs/aws-panorama-sample/graph.json` – Packages**  

```
        "packages": [
            {
                "name": "123456789012::SAMPLE_CODE",
                "version": "1.0"
            },
            {
                "name": "123456789012::SQUEEZENET_PYTORCH_V1",
                "version": "1.0"
            },
            {
                "name": "panorama::abstract_rtsp_media_source",
                "version": "1.0"
            },
            {
                "name": "panorama::hdmi_data_sink",
                "version": "1.0"
            }
        ],
```

The first two packages are defined within the application, in the `packages` directory\. They contain the code and model specific to this application\. The second two packages are generic camera and display packages provided by the AWS Panorama service\. The `abstract_rtsp_media_source` package is a placeholder for a camera that you override during deployment\. The `hdmi_data_sink` package represents the HDMI output connector on the device\.

Nodes are interfaces to packages, as well as non\-package parameters that can have default values that you override at deploy time\. The code and model packages define interfaces in `package.json` files that specify inputs and outputs, which can be video streams or a basic data type such as a float, boolean, or string\.

For example, the `code_node` node refers to an interface from the `SAMPLE_CODE` package\.

```
        "nodes": [
            {
                "name": "code_node",
                "interface": "123456789012::SAMPLE_CODE.interface",
                "overridable": false,
                "launch": "onAppStart"
            },
```

This interface is defined in the package configuration file, `package.json`\. The interface specifies that the package is business logic and that it takes a video stream named `video_in` and a floating point number named `threshold` as inputs\. The interface also specifies that the code requires a video stream buffer named `video_out` to output video to a display

**Example `packages/123456789012-SAMPLE_CODE-1.0/package.json`**  

```
{
    "nodePackage": {
        "envelopeVersion": "2021-01-01",
        "name": "SAMPLE_CODE",
        "version": "1.0",
        "description": "Computer vision application code.",
        "assets": [],
        "interfaces": [
            {
                "name": "interface",
                "category": "business_logic",
                "asset": "code_asset",
                "inputs": [
                    {
                        "name": "video_in",
                        "type": "media"
                    },
                    {
                        "name": "threshold",
                        "type": "float32"
                    }
                ],
                "outputs": [
                    {
                        "description": "Video stream output",
                        "name": "video_out",
                        "type": "media"
                    }
                ]
            }
        ]
    }
}
```

Back in the application manifest, the `camera_node` node represents a video stream from a camera\. It includes a decorator that appears in the console when you deploy the application, prompting you to choose a camera stream\.

**Example `graphs/aws-panorama-sample/graph.json` – Camera node**  

```
            {
                "name": "camera_node",
                "interface": "panorama::abstract_rtsp_media_source.rtsp_v1_interface",
                "overridable": true,
                "launch": "onAppStart",
                "decorator": {
                    "title": "Camera",
                    "description": "Choose a camera stream."
                }
            },
```

A parameter node, `threshold_param`, defines the confidence threshold parameter used by the application code\. It has a default value of 60, and can be overriden during deployment\.

**Example `graphs/aws-panorama-sample/graph.json` – Parameter node**  

```
            {
                "name": "threshold_param",
                "interface": "float32",
                "value": 60.0,
                "overridable": true,
                "decorator": {
                    "title": "Confidence threshold",
                    "description": "The minimum confidence for a classification to be recorded."
                }
            }
```

The final section of the application manifest, `edges`, makes connections between nodes\. The camera's video stream and the threshold parameter connect to the input of the code node, and the video output from the code node connects to the display\.

**Example `graphs/aws-panorama-sample/graph.json` – Edges**  

```
        "edges": [
            {
                "producer": "camera_node.video_out",
                "consumer": "code_node.video_in"
            },
            {
                "producer": "code_node.video_out",
                "consumer": "output_node.video_in"
            },
            {
                "producer": "threshold_param",
                "consumer": "code_node.threshold"
            }
        ]
```

## Building with the sample application<a name="gettingstarted-sample-adapting"></a>

You can use the sample application as a starting point for your own application\.

The name of each package must be unique in your account\. If you and another user in your account both use a generic package name such as `code` or `model`, you might get the wrong version of the package when you deploy\. Change the name of the code package to one that represents your application\.

**To rename the code package**

1. Rename the package folder: `packages/123456789012-SAMPLE_CODE-1.0/`\.

1. Update the package name in the following locations\.

****
   + **Application manifest** – `graphs/aws-panorama-sample/graph.json`
   + **Package configuration** – `packages/123456789012-SAMPLE_CODE-1.0/package.json`
   + **Build script** – `3-build-container.sh`

**To update the application's code**

1. Modify the application code in `packages/123456789012-SAMPLE_CODE-1.0/src/application.py`\.

1. To build the container, run `3-build-container.sh`\.

   ```
   aws-panorama-sample$ ./3-build-container.sh
   TMPDIR=$(pwd) docker build -t code_asset packages/123456789012-SAMPLE_CODE-1.0
   Sending build context to Docker daemon  61.44kB
   Step 1/2 : FROM public.ecr.aws/panorama/panorama-application
    ---> 9b197f256b48
   Step 2/2 : COPY src /panorama
    ---> 55c35755e9d2
   Successfully built 55c35755e9d2
   Successfully tagged code_asset:latest
   docker export --output=code_asset.tar $(docker create code_asset:latest)
   gzip -9 code_asset.tar
   Updating an existing asset with the same name
   {
       "name": "code_asset",
       "implementations": [
           {
               "type": "container",
               "assetUri": "98aaxmpl1c1ef64cde5ac13bd3be5394e5d17064beccee963b4095d83083c343.tar.gz",
               "descriptorUri": "1872xmpl129481ed053c52e66d6af8b030f9eb69b1168a29012f01c7034d7a8f.json"
           }
       ]
   }
   Container asset for the package has been succesfully built at  ~/aws-panorama-sample-dev/assets/98aaxmpl1c1ef64cde5ac13bd3be5394e5d17064beccee963b4095d83083c343.tar.gz
   ```

   The CLI automatically deletes the old container asset from the `assets` folder and updates the package configuration\.

1. To upload the packages, run `4-package-application.py`\.

1. Open the AWS Panorama console [Deployed applications page](https://console.aws.amazon.com/panorama/home#deployed-applications)\.

1. Choose an application\.

1. Choose **Replace**\.

1. Complete the steps to deploy the application\. If needed, you can make changes to the application manifest, camera streams, or parameters\.

## Changing the computer vision model<a name="gettingstarted-sample-model"></a>

The sample application includes a computer vision model\. To use your own model, modify the model node's configuration, and use the AWS Panorama Application CLI to import it as an asset\.

The following example uses an MXNet SSD ResNet50 model that you can download from this guide's GitHub repo: [ssd\_512\_resnet50\_v1\_voc\.tar\.gz](https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v0.1-preview/ssd_512_resnet50_v1_voc.tar.gz)

**To change the sample application's model**

1. Rename the package folder to match your model\. For example, to `packages/123456789012-SSD_512_RESNET50_V1_VOC-1.0/`\.

1. Update the package name in the following locations\.

****
   + **Application manifest** – `graphs/aws-panorama-sample/graph.json`
   + **Package configuration** – `packages/123456789012-SSD_512_RESNET50_V1_VOC-1.0/package.json`

1. In the package configuration file \(`package.json`\)\. Change the `assets` value to a blank array\.

   ```
   {
       "nodePackage": {
           "envelopeVersion": "2021-01-01",
           "name": "SSD_512_RESNET50_V1_VOC",
           "version": "1.0",
           "description": "Compact classification model",
           "assets": [],
   ```

1. Open the package descriptor file \(`descriptor.json`\)\. Update the `framework` and `shape` values to match your model\.

   ```
   {
       "mlModelDescriptor": {
           "envelopeVersion": "2021-01-01",
           "framework": "MXNET",
           "inputs": [
               {
                   "name": "data",
                   "shape": [ 1, 3, 512, 512 ]
               }
           ]
       }
   }
   ```

   The value for **shape**, `1,3,512,512`, indicates the number of images that the model takes as input \(1\), the number of channels in each image \(3\-\-red, green, and blue\), and the dimensions of the image \(512 x 512\)\. The values and order of the array varies among models\.

1. Import the model with the AWS Panorama Application CLI\. The AWS Panorama Application CLI copies the model and descriptor files into the `assets` folder with unique names, and updates the package configuration\.

   ```
   aws-panorama-sample$ panorama-cli add-raw-model --model-asset-name model-asset \
   --model-local-path ssd_512_resnet50_v1_voc.tar.gz \
   --descriptor-path packages/123456789012-SSD_512_RESNET50_V1_VOC-1.0/descriptor.json \
   --packages-path packages/123456789012-SSD_512_RESNET50_V1_VOC-1.0
   {
       "name": "model-asset",
       "implementations": [
           {
               "type": "model",
               "assetUri": "b1a1589afe449b346ff47375c284a1998c3e1522b418a7be8910414911784ce1.tar.gz",
               "descriptorUri": "a6a9508953f393f182f05f8beaa86b83325f4a535a5928580273e7fe26f79e78.json"
           }
       ]
   }
   ```

1. To upload the model, run `panorama-cli package-application`\.

   ```
   $ panorama-cli package-application
   Uploading package SAMPLE_CODE
   Patch Version 1844d5a59150d33f6054b04bac527a1771fd2365e05f990ccd8444a5ab775809 already registered, ignoring upload
   Uploading package SSD_512_RESNET50_V1_VOC
   Patch version for the package 244a63c74d01e082ad012ebf21e67eef5d81ce0de4d6ad1ae2b69d0bc498c8fd
   upload: assets/b1a1589afe449b346ff47375c284a1998c3e1522b418a7be8910414911784ce1.tar.gz to s3://arn:aws:s3:us-west-2:454554846382:accesspoint/panorama-123456789012-wc66m5eishf4si4sz5jefhx
   63a/123456789012/nodePackages/SSD_512_RESNET50_V1_VOC/binaries/b1a1589afe449b346ff47375c284a1998c3e1522b418a7be8910414911784ce1.tar.gz
   upload: assets/a6a9508953f393f182f05f8beaa86b83325f4a535a5928580273e7fe26f79e78.json to s3://arn:aws:s3:us-west-2:454554846382:accesspoint/panorama-123456789012-wc66m5eishf4si4sz5jefhx63
   a/123456789012/nodePackages/SSD_512_RESNET50_V1_VOC/binaries/a6a9508953f393f182f05f8beaa86b83325f4a535a5928580273e7fe26f79e78.json
   {
       "ETag": "\"2381dabba34f4bc0100c478e67e9ab5e\"",
       "ServerSideEncryption": "AES256",
       "VersionId": "KbY5fpESdpYamjWZ0YyGqHo3.LQQWUC2"
   }
   Registered SSD_512_RESNET50_V1_VOC with patch version 244a63c74d01e082ad012ebf21e67eef5d81ce0de4d6ad1ae2b69d0bc498c8fd
   Uploading package SQUEEZENET_PYTORCH_V1
   Patch Version 568138c430e0345061bb36f05a04a1458ac834cd6f93bf18fdacdffb62685530 already registered, ignoring upload
   ```

1. Update the application code\. Most of the code can be reused\. The code specific to the model's response is in the `process_results` method\.

   ```
       def process_results(self, inference_results, stream):
           """Processes output tensors from a computer vision model and annotates a video frame."""
           for class_tuple in inference_results:
               indexes = self.topk(class_tuple[0])
           for j in range(2):
               label = 'Class [%s], with probability %.3f.'% (self.classes[indexes[j]], class_tuple[0][indexes[j]])
               stream.add_label(label, 0.1, 0.25 + 0.1*j)
   ```

   Depending on your model, you might also need to update the `preprocess` method\.

## Preprocessing images<a name="gettingstarted-sample-preprocessing"></a>

Before the application sends an image to the model, it prepares it for inference by resizing it and normalizing color data\. The model that the application uses requires a 224 x 224 pixel image with three color channels, to match the number of inputs in its first layer\. The application adjusts each color value by converting it to a number between 0 and 1, subtracting the average value for that color, and dividing by the standard deviation\. Finally, it combines the color channels and converts it to a NumPy array that the model can process\.

**Example [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py) – Preprocessing**  

```
    def preprocess(self, img, width):
        resized = cv2.resize(img, (width, width))
        mean = [0.485, 0.456, 0.406]
        std = [0.229, 0.224, 0.225]
        img = resized.astype(np.float32) / 255.
        img_a = img[:, :, 0]
        img_b = img[:, :, 1]
        img_c = img[:, :, 2]
        # Normalize data in each channel
        img_a = (img_a - mean[0]) / std[0]
        img_b = (img_b - mean[1]) / std[1]
        img_c = (img_c - mean[2]) / std[2]
        # Put the channels back together
        x1 = [[[], [], []]]
        x1[0][0] = img_a
        x1[0][1] = img_b
        x1[0][2] = img_c
        return np.asarray(x1)
```

This process gives the model values in a predictable range centered around 0\. It matches the preprocessing applied to images in the training dataset, which is a standard approach but can vary per model\.

## Uploading metrics with the SDK for Python<a name="gettingstarted-sample-metrics"></a>

The sample application uses the SDK for Python to upload metrics to Amazon CloudWatch\.

**Example [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py) – SDK for Python**  

```
    def process_streams(self):
        """Processes one frame of video from one or more video streams."""
        ...
            logger.info('epoch length: {:.3f} s ({:.3f} FPS)'.format(epoch_time, epoch_fps))
            logger.info('avg inference time: {:.3f} ms'.format(avg_inference_time))
            logger.info('max inference time: {:.3f} ms'.format(max_inference_time))
            logger.info('avg frame processing time: {:.3f} ms'.format(avg_frame_processing_time))
            logger.info('max frame processing time: {:.3f} ms'.format(max_frame_processing_time))
            self.inference_time_ms = 0
            self.inference_time_max = 0
            self.frame_time_ms = 0
            self.frame_time_max = 0
            self.epoch_start = time.time()
            self.put_metric_data('AverageInferenceTime', avg_inference_time)
            self.put_metric_data('AverageFrameProcessingTime', avg_frame_processing_time)
 
    def put_metric_data(self, metric_name, metric_value):
        """Sends a performance metric to CloudWatch."""
        namespace = 'AWSPanoramaApplication'
        dimension_name = 'Application Name'
        dimension_value = 'aws-panorama-sample'
        try:
            metric = self.cloudwatch.Metric(namespace, metric_name)
            metric.put_data(
                Namespace=namespace,
                MetricData=[{
                    'MetricName': metric_name,
                    'Value': metric_value,
                    'Unit': 'Milliseconds',
                    'Dimensions': [
                        {
                            'Name': dimension_name,
                            'Value': dimension_value
                        },
                        {
                            'Name': 'Device ID',
                            'Value': self.device_id
                        }
                    ]
                }]
            )
            logger.info("Put data for metric %s.%s", namespace, metric_name)
        except ClientError:
            logger.warning("Couldn't put data for metric %s.%s", namespace, metric_name)
        except AttributeError:
            logger.warning("CloudWatch client is not available.")
```

It gets permission from a runtime role that you assign during deployment\. The role is defined in the `aws-panorama-sample.yml` AWS CloudFormation template\.

```
Resources:
  runtimeRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          -
            Effect: Allow
            Principal:
              Service:
                - panorama.amazonaws.com
            Action:
              - sts:AssumeRole
      Policies:
        - PolicyName: cloudwatch-putmetrics
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action: 'cloudwatch:PutMetricData'
                Resource: '*'
      Path: /service-role/
```

The sample application installs the SDK for Python and other dependencies with pip\. When you build the application container, the `Dockerfile` runs commands to install libraries on top of what comes with the base image\.

**Example Dockerfile**  

```
FROM public.ecr.aws/panorama/panorama-application
WORKDIR /panorama
COPY . .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
```

To use the AWS SDK in your application code, first modify the template to add permissions for all API actions that the application uses\. Update the AWS CloudFormation stack by running the `1-create-role.sh` each time you make a change\. Then, deploy changes to your application code\.

For actions that modify or use existing resources, it is a best practice to minimize the scope of this policy by specifying a name or pattern for the target `Resource` in a separate statement\. For details on the actions and resources supported by each service, see [Action, resources, and condition keys](https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html) in the Service Authorization Reference

## Next steps<a name="gettingstarted-sample-nextsteps"></a>

For instructions on using the AWS Panorama Application CLI to build applications and create packages from scratch, see the CLI's README\.

****
+ [github\.com/aws/aws\-panorama\-cli](https://github.com/aws/aws-panorama-cli)

For more sample code and a test utility that you can use to validate your application code prior to deploying, visit the AWS Panorama samples repository\.

****
+ [github\.com/aws\-samples/aws\-panorama\-samples](https://github.com/aws-samples/aws-panorama-samples)