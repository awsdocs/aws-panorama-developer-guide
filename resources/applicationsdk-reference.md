# Application SDK reference

The AWS Panorama Application SDK defines the following classes. 

**Classes**
+ [node](#node)
+ [port](#port)
+ [media](#media)

# node

Node is the class constructor for any AWS Panorama application. Your application code is contained in a class that inherits from `panoramasdk.node`. 

**node.node()**

***Parameters:***
*None*

***Return Value:***
Node object

***Exceptions:***
If the node cannot be instantiated, an exception is thrown. 
e.g. when application platform core cannot identify the node per application graph. 

***Example***

```python
class Application(panoramasdk.node):
    def __init__(self):
        """Initializes the application's attributes with parameters from the interface, and default values."""
        self.MODEL_NODE = "model_node"
        self.MODEL_DIM = 512
        self.frame_num = 0
        self.threshold = 50.
        # Desired class
        self.classids = [14.]
        
        try:
            # Parameters
            logger.info('Getting parameters')
            self.threshold = self.inputs.threshold.get()
            self.region = self.inputs.region.get()
            
        except:
            logger.exception('Error during initialization.')
        finally:
            logger.info('Initialiation complete.')
            logger.info('Threshold: {}'.format(self.threshold))
            logger.info('Region: {}'.format(self.region))
...
def main():
    try:
        logger.info("INITIALIZING APPLICATION")
        app = Application()
        logger.info("PROCESSING STREAMS")
        while True:
            app.process_streams()
    except:
        logger.exception('Exception during processing loop.')

logger = get_logger(level=logging.INFO)
main()
```

**node.call(name,  input,  time_out = None)**'

Callable API is used to “call” another node (listed in the application graph manifest) 

Name must match that of one of the nodes defined and listed by the application graph manifest. If a valid node with the name exists, it will be connected to the calling process and pipeline will be built and the input will be sent out to the callable node through the constructed pipeline.

This function is a blocking call until either result of the callable node is returned or otherwise either the timeout is reached or  calling node is terminated. This function returns a tuple of numpy arrays

**NOTE**: Right now we only support that a model node being callable node

***Parameters:***
**name**
name of the node to be called 

**input**
Input can either be a media object or a dictionary of numpy array (dictionary key comes from Neo model meta data.

**time_out**
Time out in second, default is set to None (indicating there is no time out) 

***Exceptions:***
Exception is thrown when input format is incorrect, or callable name is invalid 

***Examples:***
Three ways to call the model callable node

**Method 1**
```python
out = self.__node.call("model_name", {
    'image':media_object.image,
    'transform': batch_array.astype('float32'),
    'bbox': batch_bbx.astype('float32'),
    'index': np.array([i for i in range(self.batch_size)], dtype='float32')
})
```
**Method 2**
```python
media_object = self.__node.inputs.video_in.get()
out = self.__node.call("model_name", media_object)
```
**Method 3**
```python
media_object = self.__node.inputs.video_in.get()
media_array = media_object.image
media_array_prep = preprocessed(media_array)

out = self.__node.call("model_name", media_array_prep)
```

**node.inputs()**
“inputs” member represents the list of input ports. The list gets populated with input port objects as defined in the node interface, for example:

| Input Port Name as per JSON interface | Access Name |
| ------ | ------ |
| example_app | node.inputs.example_app|
| threshold | node.inputs.threshold|
| video_in | node.inputs.video_in|

***Example :***
Please look at the example for node.outputs for a combined example
    
**node.outputs()**

“outputs” member represents the list of output ports. The list gets populated with output port objects as defined in the node interface, for example:

| Input Port Name as per JSON interface | Access Name |
| ------ | ------ |
| video_out | node.outputs.video_out|

***Example :***
```python
def process_streams(self):
    """Processes one frame of video from one or more video streams."""
    self.frame_num += 1
    logger.debug(self.frame_num)

    # Loop through attached video streams
    streams = self.inputs.video_in.get()
    for stream in streams:
        self.process_media(stream)

    self.outputs.video_out.put(streams)
```

# port

Manages an instance of a port of a node and used to read and write pipeline data 

**port.put(data_tuple)**

Sends the specified tuple of data to the stream FIFOs of the port.

***Parameters:***
**data_tuple**
Tuple containing data instances to output from the port; the format of “data” objects has to match the port format as defined by the interface. *For now data tuple should only contain media object.* 

***Return Value:***
None

***Exceptions:***
If SDK is unable to convert “data” objects to the port format, an exception is thrown.

***Example**
```python
self.outputs.video_out.put(frame)
```
    
**port.get()**
get the next available *set of* values from the port streams
    
***Return Value:***
Returned data can be a literal (string, integer, float) or stream/pipeline data (e.g. media frame)
Literal values are like string/integer/float values that can be used as parameter of the application

***Exceptions:***
If SDK is unable to convert “data” objects to the port format, an exception is thrown.

***Example***
```python
threshold1 = self.inputs.threshold.get()
threshold2 = self.inputs.threshold.get()
threshold2 == threshold2
self.inputs.url.get()
```

Pipeline data will be dequeued and returned as a media object.
```python
media_object = self.inputs.video_in.get()
```
    
# media

Built-in values:
| Key | Type | Access | Description|
| ------ | ------ | ------ | ------ |
| image | numpy_array  | read only | Numpy array representation of the image frame |
| is_cached | boolean | read only | Indicates if the media has already been retrieved |
| stream_id | string | read only | Camera data source name |
| stream_uri | string | read only | Camera stream URL |
| time_stamp | tuple | read only | Original frame timestamp as it comes from the source (sec, µsec) |

**media.add_label(text, x, y)**

Add a text label to the frame represented by the media object.
The label is not drawn on the frame, but instead is associated as metadata only for later processing

***Parameters:***
**x, y**
Label coordinates; specified in [0..1) range.

***text***
Text of the label.

***Return Value:***
None

***Example:***
See combined example with media.add_rect
    
**media.add_rect(left, top, right, bottom)**

Add a rectangle to the frame represented by the media object.
The rectangle is not drawn on the frame, but instead is associated as metadata only for later processing.

***Parameters:***
**left, top, right, bottom**
Rectangle coordinates; specified in [0..1) range

***Return Value:***
None

***Example:***
```python
def process_results(self, inference_results, stream):
    """Processes output tensors from a computer vision model and annotates a video frame."""
    if inference_results is None:
        logger.warning("Inference results are None.")
        return

    num_people = 0

    class_data = None # Class Data
    bbox_data = None # Bounding Box Data
    conf_data = None # Confidence Data
    
    # Pulls data from the class holding the results
    # inference_results is a class, which can be iterated through
    # but inference_results has no index accessors (cannot do inference_results[0])

    k = 0
    for det_data in inference_results:
        if k == 0:
            class_data = det_data[0]
        if k == 1:
            conf_data = det_data[0]
        if k == 2:
            bbox_data = det_data[0]
            for a in range(len(conf_data)):
                if conf_data[a][0] * 100 > self.threshold and class_data[a][0] in self.classids:
                    (left, top, right, bottom) = np.clip(det_data[0][a]/self.MODEL_DIM,0,1)
                    stream.add_rect(left, top, right, bottom)
                    num_people += 1
                else:
                    continue
        k += 1
    
    logger.info('# people {}'.format(str(num_people)))
    stream.add_label('# people {}'.format(str(num_people)), 0.1, 0.1)
```
