# Application SDK reference
The AWS Panorama Application SDK defines the following classes. 

For an introduction to writing and application and running inference with a model, see [Authoring application code](../docs-source/applications-code.md).

**Classes**
+ [base](#applications-sdk-base)
+ [model](#applications-sdk-model)
+ [input_array](#applications-sdk-input)
+ [output_array](#applications-sdk-output)
+ [batch_set](#applications-sdk-base-set)
+ [batch](#applications-sdk-batch)
+ [media](#applications-sdk-media)

## base<a name="applications-sdk-base"></a>

The base class for AWS Panorama application. Your application code is contained in a class that inherits from `panoramasdk.base` and implements its interface.

**Interface methods**
+ `interface(self)` - Returns an object that defines the application's `parameters`, `inputs`, and `outputs`. You can use the `parameters` field to declare the application's high-level settings. The `inputs` and `outputs` have preset values.

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

+ `init(self, parameters, inputs, outputs)` - Perform one time initialization operations such as loading models and creating reusable resources such as AWS SDK clients.
+ `entry(self, inputs, outputs)` - Process frames of video from one or more camera streams. `inputs.video_in[]` is an array of [media](#applications-sdk-media) objects that contain image data. Process images with a model and output results.

**Instance methods**
+ `run()` - Starts the application. In your application's `main` function, you instantiate the application class and invoke `run()` on it.

## model<a name="applications-sdk-model"></a>

The `model` class represents a computer vision model. When you create an application in the AWS Panorama console, you import a model and give it a name. AWS Panorama includes this model with your application code when you deploy the application to an appliance.

**Instance methods**
+ `model.open(name)` – Opens a model by name. Use the name that you entered when you imported the model in the AWS Panorama console.
+ `model.get_input(index)` – Gets details about an input for a model. To distinguish between multiple inputs, specify a numerical index. Returns a `panoramasdk.input_array`
+ `model.get_output(index)` – Gets details about an output for a model. To distinguish between multiple outputs, specify a numerical index. Returns a `panoramasdk.output_array`
+ `model.get_batch_size()` – Gets the input batch size for the model \(an integer\).
+ `model.get_input_count()` – Gets the number of inputs that the model requires \(an integer\).
+ `model.get_output_count()` – Gets the number of outputs that the model produces \(an integer\).
+ `model.get_input_names()` – Gets the names of inputs that the model requires \(a tuple of strings\).
+ `model.get_output_names()` – Gets the names of outputs that the model produces \(a tuple of strings\).
+ `model.batch(input_index, input_data)` – Sends an array of data \(a numpy array\) to an input \(by index\) for inference.
+ `model.flush()` – Runs inference with the provided batch input.
+ `model.get_result()` – Gets inference results \(a `panoramasdk.batch_set`\).
+ `model.release_result(batch_set)` – Deletes an inference result after the result has been processed.
+ `model.finish()` – Stops the model's inference thread to clean up resources.

## input\_array<a name="applications-sdk-input"></a>

Represents the input for a model.

**Instance methods**
+ `input_array.get_index()` – Gets the index of the input.
+ `input_array.get_name()` – Gets the name of the input.
+ `input_array.get_type()` – Gets the type of the input.
+ `input_array.get_dims()` – Gets the shape of the input.
+ `input_array.get_size()` – Gets the size of the input data.
+ `input_array.get_four_cc()` – Gets the input data's four character code, such as `RGBA` or `BGR3`.
+ `input_array.get_range()` – Gets the valid range for values in the input \(a tuple of integers\). For example, `(0,255)`.

## output\_array<a name="applications-sdk-output"></a>

Represents an output for a model.

**Instance methods**
+ `output_array.get_index()` – Gets the index of the output.
+ `output_array.get_name()` – Gets the name of the output.
+ `output_array.get_type()` – Gets the type of the output.
+ `output_array.get_dims()` – Gets the shape of the output.
+ `output_array.get_size()` – Gets the size of the output data.

## batch\_set<a name="applications-sdk-base-set"></a>

A set of `panoramasdk.batch` objects, one for each output of a model.

**Instance methods**
+ `output_array.size()` – The number of outputs.
+ `output_array.get(index)` – Gets the batch of results for an output by index.

## batch<a name="applications-sdk-batch"></a>

A batch of results for a model output, retrieved from a `panoramasdk.batch_set`.

**Instance methods**
+ `batch.get(index, destination)` – Gets an output from a batch and writes it to a destination \(a numpy array\).

## media<a name="applications-sdk-media"></a>

A frame of video from a camera stream.

**Instance methods**
+ `media.image()` – Gets the frame's image data \(a numpy array\).
+ `media.add_rect(rect)` – Draws a rectangle around an object. The input is a tuple of 4 floating point values: left, right, top, bottom.
+ `media.add_label(text, left_pos, top_pos)` – Adds text to the image. The input is a string and two floats: a horizontal offset and vertical offset.
+ `media.stream_uri()` – Gets the URI of the camera stream that provided the frame.
+ `media.time_stamp()` – Gets the timestamp of the image frame in both seconds and milliseconds \(a tuple of 2 numbers\).