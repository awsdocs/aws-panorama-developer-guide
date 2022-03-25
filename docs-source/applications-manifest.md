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

## JSON schema<a name="applications-manifest-schema"></a>

The format of application manifest and override documents is defined in a JSON schema\. You can use the JSON schema to validate your configuration documents before deploying\. The JSON schema is available in this guide's GitHub repository\.

****
+ **JSON schema** – [aws\-panorama\-developer\-guide/resources](https://github.com/awsdocs/aws-panorama-developer-guide/tree/main/resources)