# Supported computer vision models<a name="gettingstarted-models"></a>

AWS Panorama integrates with Amazon SageMaker to support importing and compiling computer vision models for AWS Panorama applications\. You can start with a provided model, or build your own model with a supported framework\. You can import a model from an Amazon Simple Storage Service \(Amazon S3\) bucket or from the output of a SageMaker job\.

When you deploy an application, AWS Panorama uses the SageMaker Neo compiler to compile it\. SageMaker Neo is a compiler that optimizes models to run efficiently on edge devices such as the AWS Panorama Appliance\. AWS Panorama supports the versions of PyTorch, Apache MXNet, and TensorFlow that are supported for edge devices by SageMaker Neo\.

**Note**  
For a list of models that have been tested with AWS Panorama, see [Model compatibility](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/resources/model-compatibility.md)\.

For more information, see the following topics:

****
+ [Compile and deploy models with Amazon SageMaker Neo](https://docs.aws.amazon.com/sagemaker/latest/dg/neo.html)
+ [SageMaker Neo supported frameworks and operators](https://aws.amazon.com/releasenotes/sagemaker-neo-supported-frameworks-and-operators/)