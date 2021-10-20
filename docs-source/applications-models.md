# Computer vision models<a name="applications-models"></a>

A *computer vision model* is a software program that is trained to detect objects in images\. A model learns to recognize a set of objects by first analyzing images of those objects through training\. A computer vision model takes an image as input and outputs information about the objects that it detects, such as the type of object and its location\. AWS Panorama supports computer vision models built with PyTorch, Apache MXNet, and TensorFlow\.

**Note**  
For a list of pre\-built models that have been tested with AWS Panorama, see [Model compatibility](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/resources/model-compatibility.md)\.

You can use a [sample model](#applications-models-sample) or build your own\. A model can detect multiple objects in an image, and each result can have multiple outputs, such as the name of a class, a confidence rating, and a bounding box\. You can train a model outside of AWS and store it in Amazon Simple Storage Service \(Amazon S3\), or train it with Amazon SageMaker\. To build a model in SageMaker, you can use the built\-in [image classification algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html)\. AWS Panorama can reference the training job to find the trained model that it created in Amazon S3\.

**Topics**
+ [Sample model](#applications-models-sample)
+ [Building a custom model](#applications-models-custom)
+ [Using models in code](#applications-models-using)
+ [Training models](#applications-models-training)

## Sample model<a name="applications-models-sample"></a>

This guide uses a sample object detection model\. The sample model uses the object detection algorithm to identify multiple objects in an image\. For each object, the model outputs the type of object, a confidence score, and coordinates of a bounding box\. It uses the Single Shot multibox detector \(SSD\) framework and the ResNet base network\.

****
+ [Download the sample model](https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v0.1-preview/ssd_512_resnet50_v1_voc.tar.gz)

## Building a custom model<a name="applications-models-custom"></a>

You can use models that you build in PyTorch, Apache MXNet, and TensorFlow in AWS Panorama applications\. As an alternative to building and training models in SageMaker, you can use a trained model or build and train your own model with a supported framework and export it in a local environment or in Amazon EC2\.

**Note**  
For details about the framework versions and file formats supported by SageMaker Neo, see [Supported Frameworks](https://docs.aws.amazon.com/sagemaker/latest/dg/neo-supported-devices-edge-frameworks.html) in the Amazon SageMaker Developer Guide\.

The repository for this guide provides a sample application that demonstrates this workflow for a Keras model in TensorFlow `SavedModel` format\. It uses TensorFlow 1\.15 and can run locally in a virtual environment or in a Docker container\. The sample app also includes templates and scripts for building the model on an Amazon EC2 instance\.

****
+ [Custom model sample application](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/custom-model)

![\[\]](http://docs.aws.amazon.com/panorama/latest/dev/images/sample-custom-model.png)

AWS Panorama uses SageMaker Neo to compile models for use on the AWS Panorama Appliance\. For each framework, use the [format that's supported by SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo-compilation-preparing-model.html), and package the model in a `.tar.gz` archive\.

For more information, see [Compile and Deploy Models with Neo ](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html) in the Amazon SageMaker Developer Guide\.

## Using models in code<a name="applications-models-using"></a>

**Example [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py) – Inference**  

```
    def process_media(self, stream):
        """Runs inference on a frame of video."""
        image_data = preprocess(stream.image,self.MODEL_DIM)
        logger.debug('Image data: {}'.format(image_data))
        # Run inference
        inference_start = time.time()
        inference_results = self.call({"data":image_data}, self.MODEL_NODE)
         # Log metrics
        inference_time = (time.time() - inference_start) * 1000
        if inference_time > self.inference_time_max:
            self.inference_time_max = inference_time
        self.inference_time_ms += inference_time
        # Process results (classification)
        self.process_results(inference_results, stream)
```

A model returns one or more results, which can include probabilities for detected classes, location information, and other data\. The following example shows a function that processes results from basic classification model\. The model returns an array of probabilities, which is the first and only value in the results array\. The application code finds the values with the highest probabilities and maps them to labels in a resource file that's loaded during initialization\.

**Example [application\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/application.py) – Processing results**  

```
    def process_results(self, inference_results, stream):
        """Processes output tensors from a computer vision model and annotates a video frame."""
        if inference_results is None:
            logger.warning("Inference results are None.")
            return
        max_results = 5
        logger.debug('Inference results: {}'.format(inference_results))
        class_tuple = inference_results[0]
        enum_vals = [(i, val) for i, val in enumerate(class_tuple[0])]
        sorted_vals = sorted(enum_vals, key=lambda tup: tup[1])
        top_k = sorted_vals[::-1][:max_results]
        indexes =  [tup[0] for tup in top_k]

        for j in range(max_results):
            label = 'Class [%s], with probability %.3f.'% (self.classes[indexes[j]], class_tuple[0][indexes[j]])
            stream.add_label(label, 0.1, 0.1 + 0.1*j)
```

## Training models<a name="applications-models-training"></a>

When you train a model, use images from the target environment, or from a test environment that closely resembles the target environment\. Consider the following factors that can affect model performance:

****
+ **Lighting** – The amount of light that is reflected by a subject determines how much detail the model has to analyze\. A model trained with images of well\-lit subjects might not work well in a low\-light or backlit environment\.
+ **Resolution** – The input size of a model is typically fixed at a resolution between 224 and 512 pixels wide in a square aspect ratio\. Before you pass a frame of video to the model, you can downscale or crop it to fit the required size\.
+ **Image distortion** – A camera's focal length and lens shape can cause images to exhibit distortion away from the center of the frame\. The position of a camera also determines which features of a subject are visible\. For example, an overhead camera with a wide angle lens will show the top of a subject when it's in the center of the frame, and a skewed view of the subject's side as it moves farther away from center\.

To address these issues, you can preprocess images before sending them to the model, and train the model on a wider variety of images that reflect variances in real\-world environments\. If a model needs to operate in a lighting situations and with a variety of cameras, you need more data for training\. In addition to gathering more images, you can get more training data by creating variations of your existing images that are skewed or have different lighting\.