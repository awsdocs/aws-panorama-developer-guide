# Computer vision models<a name="applications-models"></a>

A *computer vision model* is a software program that is trained to detect objects in images\. A model learns to recognize a set of objects by first analyzing images of those objects through training\. A computer vision model takes an image as input and outputs information about the objects that it detects, such as the type of object and its location\. AWS Panorama supports computer vision models built with PyTorch, Apache MXNet, and TensorFlow\.

**Note**  
For a list of pre\-built models that have been tested with AWS Panorama, see [Model compatibility](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/resources/model-compatibility.md)\.

You can use a [sample model](#applications-models-sample) or build your own\. A model can detect multiple objects in an image, and each result can have multiple outputs, such as the name of a class, a confidence rating, and a bounding box\. You can train a model outside of AWS and store it in Amazon Simple Storage Service \(Amazon S3\), or train it with Amazon SageMaker\. To build a model in SageMaker, you can use the built\-in [image classification algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html)\. AWS Panorama can reference the training job to find the trained model that it created in Amazon S3\.

**Important**  
Whether you import a model from SageMaker or from Amazon S3, the name of the Amazon S3 bucket where the model is stored must contain `aws-panorama`\. The [service role](permissions-services.md) that gives AWS Panorama permission to access objects in Amazon S3 enforces this naming requirement\.

**Topics**
+ [Sample model](#applications-models-sample)
+ [Using models in code](#applications-models-using)
+ [Training models](#applications-models-training)

## Sample model<a name="applications-models-sample"></a>

This guide uses a sample object detection model\. The sample model uses the object detection algorithm to identify multiple objects in an image\. For each object, the model outputs the type of object, a confidence score, and coordinates of a bounding box\. It uses the Single Shot multibox detector \(SSD\) framework and the ResNet base network\.

****
+ [Download the sample model](https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v0.1-preview/ssd_512_resnet50_v1_voc.tar.gz)

To get started with the sample model, see [Deploying the AWS Panorama sample application](gettingstarted-deploy.md)\.

## Using models in code<a name="applications-models-using"></a>

On the appliance, model files are stored in a folder named after the model resource that you create in the AWS Panorama console when you [create an application](gettingstarted-deploy.md#gettingstarted-deploy-create)\. The application code uses the directory name to reference the model and load it with the AWS Panorama Application SDK\.

For example, the following initialization code loads a model named `my-model`\.

**Example [lambda\_function\.py](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/code/lambda_function.py) – Initialization**  

```
    def init(self, parameters, inputs, outputs):
        try:
            self.threshold = parameters.threshold
            self.person_index = parameters.person_index
            self.frame_num = 0
            self.number_people = 0
            self.colours = np.random.rand(32, 3)

            self.model = panoramasdk.model()
            self.model.open('my-model', 1)

            print("Creating input and output arrays")
            class_info = self.model.get_output(0)
            prob_info = self.model.get_output(1)
            rect_info = self.model.get_output(2)

            self.class_array = np.empty(class_info.get_dims(), dtype=class_info.get_type())
            self.prob_array = np.empty(prob_info.get_dims(), dtype=prob_info.get_type())
            self.rect_array = np.empty(rect_info.get_dims(), dtype=rect_info.get_type())
```

## Training models<a name="applications-models-training"></a>

When you a model, use images from the target environment, or from a test environment that closely resembles the target environment\. Consider the following factors that can affect model performance:

****
+ **Lighting** – The amount of light that is reflected by a subject determines how much detail the model has to analyze\. A model trained with images of well\-lit subjects might not work well in a low\-light or backlit environment\.
+ **Resolution** – The input size of a model is typically fixed at a resolution between 224 and 512 pixels wide in a square aspect ratio\. Before you pass a frame of video to the model, you can downscale or crop it to fit the required size\.
+ **Image distortion** – A camera's focal length and lens shape can cause images to exhibit distortion away from the center of the frame\. The position of a camera also determines which features of a subject are visible\. For example, an overhead camera with a wide angle lens will show the top of a subject when its in the center of the frame, and a skewed view of the subject's side as it moves farther away from center\.

To address these issues, you can preprocess images before sending them to the model, and train the model on a wider variety of images that reflect variances in real\-world environments\. If a model needs to operate in a lighting situations and with a variety of cameras, you need more data for training\. In addition to gathering more images, you can get more training data by creating variations of your existing images that are skewed or have different lighting\.