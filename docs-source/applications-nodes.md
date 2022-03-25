# Application nodes<a name="applications-nodes"></a>

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