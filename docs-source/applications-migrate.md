# Migrate applications from preview<a name="applications-migrate"></a>

Applications from the AWS Panorama preview are not compatible with the hardware or software for general availability\. If you've developed applications with the AWS Panorama Appliance Developer Kit, you must migrate them to the new application architecture\. You can reuse portions of your application code, but dependency management, application SDK methods, and deployment tools are all new for general availability\.

If you haven't already, [deploy the sample application](gettingstarted-deploy.md) to familiarize yourself with the new development process and application structure\.

**Topics**
+ [Application code](#applications-migrate-code)
+ [AWS Panorama Application SDK](#applications-migrate-appsdk)
+ [Interface](#applications-migrate-interface)
+ [Dependencies](#applications-migrate-dependencies)

## Application code<a name="applications-migrate-code"></a>

In preview, you created an application class that inherits from `panoramasdk.base` and implements abstract methods for defining an interface, initialization, and processing images\. For general availability, you inherit from `panoramasdk.node` and there are no abstract methods\. You define the entrypoint for the application in a descriptor file and manage the lifecycle of the application class in a script, which can be the main method of your application class\.

****
+ [descriptor\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/descriptor.json)–Descriptor file with entrypoint\.
+ [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py#L192-L206) – Main method\.

The sample application code contains many boilerplate methods that you can use without modification\. The areas where you need to add your own code are the `preprocess` method, which prepares images for inference, and the `process_results` method, which processes the output from the model and modifies the output video stream\.

## AWS Panorama Application SDK<a name="applications-migrate-appsdk"></a>

All of the AWS Panorama Application SDK methods are new or different\. See the sample application code for examples of the new methods\.

****
+ [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py#L127-L128) – Stream methods \(`add_label` and `add_rect`\)\.
+ [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py#L63) – Video input\.
+ [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py#L91) – Video output\.


****  

| Element | Preview | General availability | 
| --- | --- | --- | 
|  **Base class**  |  `panoramasdk.base`  |  `panoramasdk.node`  | 
|  **Interface**  |  `interface(self)` instance method  |  [Package configuration](#applications-migrate-interface)  | 
|  **Initialization**  |  `init(self, parameters, inputs, outputs)` abstract instance method  |  None  | 
|  **Process stream**  |  `entry(self, inputs, outputs)` abstract instance method  |  None  | 
|  **Start application**  |  `run()` instance method  |  None  | 
|  **Access parameters**  |  `init()` `parameters` argument  |  `inputs` base class attribute <pre>self.inputs.threshold.get()</pre>  | 
|  **Read camera stream**  |  `entry()` `inputs` argument  |  `inputs` base class attribute <pre>self.inputs.video_in.get()</pre>  | 
|  **Read camera stream**  |  `entry()` `outputs` argument  |  `outputs` base class attribute <pre>self.outputs.video_out.put(streams)</pre>  | 
|  **Load a model**  |  `model` class  |  None  | 
|  **Run inference**  |  `model.batch(input_index, input_data)` instance method  |  `call()` base class method <pre>self.call({"data":image_data}, 'model_node_name')</pre>  | 

For more information, see [Application SDK reference](https://github.com/awsdocs/aws-panorama-developer-guide/tree/main/resources/applicationsdk-reference.md)\.

## Interface<a name="applications-migrate-interface"></a>

In preview, you defined an interface in the application class to declare parameters, inputs, and outputs\. For general availability, you use the package manifest to declare inputs and outputs\. You create nodes for camera streams and models, and map inputs and outputs in the application manifest\.

****
+ [package\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/package.json) – Package configuration\.
+ [graph\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/graphs/aws-panorama-sample/graph.json) – Application manifest\.

## Dependencies<a name="applications-migrate-dependencies"></a>

For preview, you installed Python modules locally and packaged them into a ZIP file with your application code\. For general availability, you can use the application's `Dockerfile` to install libraries with `pip`, or copy modules into the application container alongside your code\.

****
+ [Dockerfile](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/Dockerfile) – Install dependencies with pip\.