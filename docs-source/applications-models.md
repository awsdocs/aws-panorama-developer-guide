# Computer vision models<a name="applications-models"></a>

A computer vision model is a software program that is trained to detect objects in images\. A model learns to recognize a set of objects by analyzing images of those objects\. It takes an image as input and outputs information about objects that it detects\. AWS Panorama supports computer vision models built with PyTorch, Apache MXNet, and TensorFlow\.

**Note**  
For a list of models that have been tested with AWS Panorama, see [Model compatibility](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/resources/model-compatibility.md)\.

You can use sample models or build your own\. A model can detect multiple objects in an image, and each result can have multiple outputs, such as the name of a class, a confidence rating, and a bounding box\. You can train a model outside of AWS and store it in Amazon Simple Storage Service \(Amazon S3\), or train it in Amazon SageMaker\.

**Important**  
Whether you import a model from a SageMaker training job or directly from Amazon S3, the Amazon S3 bucket where the model is stored must contain `aws-panorama` in the name\.

On the appliance, the model files are stored in a folder named after the model resource that you configured in the AWS Panorama console\. The application code uses the directory name to reference the model and load it with the AWS Panorama Application SDK\.