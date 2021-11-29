# The AWS Panorama application manifest<a name="applications-manifest"></a>

When you deploy an application, you provide a configuration file called an application manifest\. This file defines the application as a graph with nodes and edges\. The application manifest is part of the application's source code and is stored in the `graphs` directory\.

**Example graphs/aws\-panorama\-sample/graph\.json**  

```
{
    "nodeGraph": {
        "envelopeVersion": "2021-01-01",
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
        "nodes": [
            {
                "name": "code_node",
                "interface": "123456789012::SAMPLE_CODE.interface"
            }
            {
                "name": "model_node",
                "interface": "123456789012::SQUEEZENET_PYTORCH_V1.interface"
            },
            {
                "name": "camera_node",
                "interface": "panorama::abstract_rtsp_media_source.rtsp_v1_interface",
                "overridable": true,
                "overrideMandatory": true,
                "decorator": {
                    "title": "IP camera",
                    "description": "Choose a camera stream."
                }
            },
            {
                "name": "output_node",
                "interface": "panorama::hdmi_data_sink.hdmi0"
            },
            {
                "name": "log_level",
                "interface": "string",
                "value": "INFO",
                "overridable": true,
                "decorator": {
                    "title": "Logging level",
                    "description": "DEBUG, INFO, WARNING, ERROR, or CRITICAL."
                }
            }
            ...
        ],
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
                "producer": "log_level",
                "consumer": "code_node.log_level"
            }
        ]
    }
}
```

Nodes are connected by edges, which specify mappings between nodes' inputs and outputs\. The output of one node connects to the input of another, forming a graph\.

**Topics**
+ [Nodes](#applications-manifest-nodes)
+ [Package configuration](#applications-manifest-interfaces)
+ [Edges](#applications-manifest-edges)
+ [Parameters](#applications-manifest-parameters)
+ [Abstract nodes](#applications-manifest-abstract)
+ [Deploy\-time configuration with overrides](#applications-manifest-overrides)
+ [JSON schema](#applications-manifest-schema)

## Nodes<a name="applications-manifest-nodes"></a>

Nodes are models, code, camera streams, output, and parameters\. A node has an interface, which defines its inputs and outputs\. The interface can be defined in a package in your account, a package provided by AWS Panorama, or a built\-in type\.

In the following example, `code_node` and `model_node` refer to the sample code and model packages included with the sample application\. `camera_node` uses a package provided by AWS Panorama to create a placeholder for a camera stream that you specify during deployment\.

**Example graph\.json – Nodes**  

```
        "nodes": [
            {
                "name": "code_node",
                "interface": "123456789012::SAMPLE_CODE.interface"
            },
            {
                "name": "model_node",
                "interface": "123456789012::SQUEEZENET_PYTORCH_V1.interface"
            },
            {
                "name": "camera_node",
                "interface": "panorama::abstract_rtsp_media_source.rtsp_v1_interface",
                "overridable": true,
                "overrideMandatory": true,
                "decorator": {
                    "title": "IP camera",
                    "description": "Choose a camera stream."
                }
            }
      ]
```

## Package configuration<a name="applications-manifest-interfaces"></a>

When you use the AWS Panorama Application CLI command `panorama-cli package-application`, the CLI uploads your application's assets to Amazon S3 and registers them with AWS Panorama\. Assets include binary files \(container images and models\) and descriptor files, which the AWS Panorama Appliance downloads during deployment\. To register a package's assets, you provide a separate package configuration file that defines the package, its assets, and its interface\.

The following example shows a package configuration for a code node with one input and one output\. The video input provides access to image data from a camera stream\. The output node sends processed images out to a display\.

**Example packages/1234567890\-SAMPLE\_CODE\-1\.0/package\.json**  

```
{
    "nodePackage": {
        "envelopeVersion": "2021-01-01",
        "name": "SAMPLE_CODE",
        "version": "1.0",
        "description": "Computer vision application code.",
        "assets": [
            {
                "name": "code_asset",
                "implementations": [
                    {
                        "type": "container",
                        "assetUri": "3d9bxmplbdb67a3c9730abb19e48d78780b507f3340ec3871201903d8805328a.tar.gz",
                        "descriptorUri": "1872xmpl129481ed053c52e66d6af8b030f9eb69b1168a29012f01c7034d7a8f.json"
                    }
                ]
            }
        ],
        "interfaces": [
            {
                "name": "interface",
                "category": "business_logic",
                "asset": "code_asset",
                "inputs": [
                    {
                        "name": "video_in",
                        "type": "media"
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

The `assets` section specifies the names of artifacts that the AWS Panorama Application CLI uploaded to Amazon S3\. If you import a sample application or an application from another user, this section can be empty or refer to assets that aren't in your account\. When you run `panorama-cli package-application`, the AWS Panorama Application CLI populates this section with the correct values\.

## Edges<a name="applications-manifest-edges"></a>

Edges map the output from one node to the input of another\. In the following example, the first edge maps the output from a camera stream node to the input of an application code node\. The names `video_in` and `video_out` are defined in the node packages' interfaces\.

**Example graph\.json – edges**  

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
```

 In your application code, you use the `inputs` and `outputs` attributes to get images from the input stream, and send images to the output stream\.

**Example application\.py – Video input and output**  

```
    def process_streams(self):
        """Processes one frame of video from one or more video streams."""
        frame_start = time.time()
        self.frame_num += 1
        logger.debug(self.frame_num)
        # Loop through attached video streams
        streams = self.inputs.video_in.get()
        for stream in streams:
            self.process_media(stream)
        ...
        self.outputs.video_out.put(streams)
```

## Parameters<a name="applications-manifest-parameters"></a>

Parameters are nodes that have a basic type and can be overridden during deployment\. A parameter can have a default value and a *decorator*, which instructs the application's user how to configure it\.

**Parameter types**
+ `string` – A string\. For example, `DEBUG`\.
+ `int32` – An integer\. For example, `20`
+ `float32` – A floating point number\. For example, `47.5`
+ `boolean` – `true` or `false`\.

The following example shows two parameters, a string and a number, which are sent to a code node as inputs\.

**Example graph\.json – Parameters**  

```
        "nodes": [
            {
                "name": "detection_threshold",
                "interface": "float32",
                "value": 20.0,
                "overridable": true,
                "decorator": {
                    "title": "Threshold",
                    "description": "The minimum confidence percentage for a positive classification."
                }
            },
            {
                "name": "log_level",
                "interface": "string",
                "value": "INFO",
                "overridable": true,
                "decorator": {
                    "title": "Logging level",
                    "description": "DEBUG, INFO, WARNING, ERROR, or CRITICAL."
                }
            }
            ...
        ],
        "edges": [
            {
                "producer": "detection_threshold",
                "consumer": "code_node.threshold"
            },
            {
                "producer": "log_level",
                "consumer": "code_node.log_level"
            }
            ...
        ]
    }
```

## Abstract nodes<a name="applications-manifest-abstract"></a>

In an application manifest, an abstract node refers to a package defined by AWS Panorama, which you can use as a placeholder in your application manifest\. AWS Panorama provides two types of abstract node\.

****
+ **Camera stream** – Choose the camera stream that the application uses during deployment\.

  *Package name* – `panorama::abstract_rtsp_media_source`

  *Interface name* – `rtsp_v1_interface`
+ **HDMI output** – Indicates that the application outputs video\.

  *Package name* – `panorama::hdmi_data_sink`

  *Interface name* – `hdmi0`

The following example shows a basic set of packages, nodes, and edges for an application that processes camera streams and outputs video to a display\. The camera node, which uses the interface from the `abstract_rtsp_media_source` package in AWS Panorama, can accept multiple camera streams as input\. The output node, which references `hdmi_data_sink`, gives application code access to a video buffer that is output from the appliance's HDMI port\.

**Example graph\.json – Abstract nodes**  

```
{
    "nodeGraph": {
        "envelopeVersion": "2021-01-01",
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
        "nodes": [
            {
                "name": "camera_node",
                "interface": "panorama::abstract_rtsp_media_source.rtsp_v1_interface",
                "overridable": true,
                "decorator": {
                    "title": "IP camera",
                    "description": "Choose a camera stream."
                }
            },
            {
                "name": "output_node",
                "interface": "panorama::hdmi_data_sink.hdmi0"
            }
        ],
        "edges": [
            {
                "producer": "camera_node.video_out",
                "consumer": "code_node.video_in"
            },
            {
                "producer": "code_node.video_out",
                "consumer": "output_node.video_in"
            }
        ]
    }
}
```

## Deploy\-time configuration with overrides<a name="applications-manifest-overrides"></a>

You configure parameters and abstract nodes during deployment\. If you use the AWS Panorama console to deploy, you can specify a value for each parameter and choose a camera stream as input\. If you use the AWS Panorama API to deploy applications, you specify these settings with an overrides document\.

An overrides document is similar in structure to an application manifest\. For parameters with basic types, you define a node\. For camera streams, you define a node and a package that maps to a registered camera stream\. Then you define an override for each node that specifies the node from the application manifest that it replaces\.

**Example overrides\.json**  

```
{
    "nodeGraphOverrides": {
        "nodes": [
            {
                "name": "my_camera",
                "interface": "123456789012::exterior-south.exterior-south"
            },
            {
                "name": "my_region",
                "interface": "string",
                "value": "us-east-1"
            }
        ],
        "packages": [
            {
                "name": "123456789012::exterior-south",
                "version": "1.0"
            }
        ],
        "nodeOverrides": [
            {
                "replace": "camera_node",
                "with": [
                    {
                        "name": "my_camera"
                    }
                ]
            },
            {
                "replace": "region",
                "with": [
                    {
                        "name": "my_region"
                    }
                ]
            }
        ],
        "envelopeVersion": "2021-01-01"
    }
}
```

In the preceding example, the document defines overrides for one string parameter and an abstract camera node\. The `nodeOverrides` tells AWS Panorama which nodes in this document override which in the application manifest\.

## JSON schema<a name="applications-manifest-schema"></a>

The format of application manifest and override documents is defined in a JSON schema\. You can use the JSON schema to validate your configuration documents before deploying\. The JSON schema is available in this guide's GitHub repository\.

****
+ **JSON schema** – [aws\-panorama\-developer\-guide/resources](https://github.com/awsdocs/aws-panorama-developer-guide/tree/main/resources)