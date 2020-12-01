# Identity\-based IAM policies for AWS Panorama<a name="permissions-roles"></a>

To grant users in your account access to AWS Panorama, you use identity\-based policies in AWS Identity and Access Management \(IAM\)\. Identity\-based policies can apply directly to IAM users, or to IAM groups and roles that are associated with a user\. You can also grant users in another account permission to assume a role in your account and access your AWS Panorama resources\.

AWS Panorama provides managed policies that grant access to AWS Panorama API actions and, in some cases, access to other services used to develop and manage AWS Panorama resources\. AWS Panorama updates the managed policies as needed, to ensure that your users have access to new features when they're released\.
+ **AWSPanoramaFullAccess** – Grants full access to AWS Panorama\. [View policy](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AWSPanoramaFullAccess)

Managed policies grant permission to API actions without restricting the resources that a user can modify\. For finer\-grained control, you can create your own policies that limit the scope of a user's permissions\.

At a minimum, an AWS Panorama user needs permission to use the following services in addition to AWS Panorama:

****
+ **Amazon Simple Storage Service \(Amazon S3\)** – To store model and Lambda function artifacts, and can be used for application output\.
+ **AWS Lambda** – To manage function code, configuration, and versions\.
+ **IAM** – To create a Lambda function, a user needs access to assign a role to the function\. You can [create an execution role with basic permissions](https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html) ahead of time, in which case the user needs only [permission to pass the role](https://docs.aws.amazon.com/lambda/latest/dg/access-control-identity-based.html)\.

****  
The first time you use [the AWS Panorama console](https://console.aws.amazon.com/panorama/home), you need permission to create service roles used by the AWS Panorama service, the AWS Panorama console, the AWS Panorama Appliance, AWS IoT Greengrass, and SageMaker\. A [service role](permissions-services.md) gives a service permission to manage resources or interact with other services\. Create these roles before granting access to your users\.

To create machine learning models or to monitor application output in the console, additional permissions are required\. To use all features of AWS Panorama, also grant a user permission to use the following services:

****
+ **Amazon SageMaker** – Develop, train, and compile machine learning models optimized for the AWS Panorama Appliance
+ **Amazon CloudWatch** – View metrics output by AWS Panorama, Lambda, and other services
+ **Amazon CloudWatch Logs** – View application logs

You can grant full access to each service or limit the scope of permissions by resource name\. The following example shows a policy that provides limited access to resources in AWS Panorama and related services\. The `Resources` key for applicable actions limits access to resources whose names start with `panorama`\.

**Example user policy**  

```
{
   "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PanoramaIoTThingAccess",
            "Effect": "Allow",
            "Action": [
                "iot:CreateThing",
                "iot:DeleteThing",
                "iot:DeleteThingShadow",
                "iot:DescribeThing",
                "iot:GetThingShadow",
                "iot:UpdateThing",
                "iot:UpdateThingShadow"
            ],
            "Resource": [
                "arn:aws:iot:*:*:thing/panorama*"
            ]
        },
        {
            "Sid": "PanoramaIoTCertificateAccess",
            "Effect": "Allow",
            "Action": [
                "iot:AttachThingPrincipal",
                "iot:DetachThingPrincipal",
                "iot:UpdateCertificate",
                "iot:DeleteCertificate",
                "iot:AttachPrincipalPolicy",
                "iot:DetachPrincipalPolicy"
            ],
            "Resource": [
                "arn:aws:iot:*:*:thing/panorama*",
                "arn:aws:iot:*:*:cert/*"
            ]
        },
        {
            "Sid": "PanoramaIoTCreateCertificateAndPolicyAccess",
            "Effect": "Allow",
            "Action": [
                "iot:CreateKeysAndCertificate",
                "iot:CreatePolicy",
                "iot:CreatePolicyVersion"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "PanoramaIoTJobAccess",
            "Effect": "Allow",
            "Action": [
                "iot:DescribeJobExecution",
                "iot:CreateJob",
                "iot:DeleteJob"
            ],
            "Resource": [
                "arn:aws:iot:*:*:job/panorama*",
                "arn:aws:iot:*:*:thing/panorama*"
            ]
        },
        {
            "Sid": "PanoramaIoTEndpointAccess",
            "Effect": "Allow",
            "Action": [
                "iot:DescribeEndpoint"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "PanoramaAccess",
            "Effect": "Allow",
            "Action": [
                "panorama:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "PanoramaS3ObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::panorama*"
            ]
        },
        {
            "Sid": "PanoramaS3Buckets",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteBucket",
                "s3:ListBucket",
                "s3:GetBucket*"
            ],
            "Resource": [
                "arn:aws:s3:::panorama*"
            ]
        },
        {
            "Sid": "PanoramaCreateS3Buckets",
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::panorama*"
            ]
        },
        {
            "Sid": "PanoramaIAMPassRoleAccess",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/AWSPanorama*",
                "arn:aws:iam::*:role/service-role/AWSPanorama*"
            ],
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "greengrass.amazonaws.com",
                        "sagemaker.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Sid": "PanoramaIAMLambdaPassRoleAccess",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/AWSPanorama*",
                "arn:aws:iam::*:role/service-role/AWSPanorama*"
            ],
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": "lambda.amazonaws.com"
                }
            }
        },
        {
            "Sid": "PanoramaGreenGrassAccess",
            "Effect": "Allow",
            "Action": [
                "greengrass:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "PanoramaLambdaAdminFunctionAccess",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "lambda:DeleteFunction",
                "lambda:GetFunction",
                "lambda:GetFunctionConfiguration",
                "lambda:ListFunctions",
                "lambda:ListVersionsByFunction",
                "lambda:PublishVersion",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:panorama*"
            ]
        },
        {
            "Sid": "PanoramaLambdaUsersFunctionAccess",
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunction",
                "lambda:GetFunctionConfiguration",
                "lambda:ListFunctions",
                "lambda:ListVersionsByFunction"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:*"
            ]
        },
        {
            "Sid": "PanoramaSageMakerWriteAccess",
            "Effect": "Allow",
            "Action": [
                "sagemaker:CreateTrainingJob",
                "sagemaker:StopTrainingJob",
                "sagemaker:CreateCompilationJob",
                "sagemaker:DescribeCompilationJob",
                "sagemaker:StopCompilationJob"
            ],
            "Resource": [
                "arn:aws:sagemaker:*:*:training-job/panorama*",
                "arn:aws:sagemaker:*:*:compilation-job/panorama*"
            ]
        },
        {
            "Sid": "PanoramaSageMakerListAccess",
            "Effect": "Allow",
            "Action": [
                "sagemaker:ListCompilationJobs"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "PanoramaSageMakerReadAccess",
            "Effect": "Allow",
            "Action": [
                "sagemaker:DescribeTrainingJob"
            ],
            "Resource": [
                "arn:aws:sagemaker:*:*:training-job/*"
            ]
        },
        {
            "Sid": "PanoramaCWLogsAccess",
            "Effect": "Allow",
            "Action": [
                "iot:AttachPolicy",
                "iot:CreateRoleAlias"
            ],
            "Resource": [
                "arn:aws:iot:*:*:policy/panorama*",
                "arn:aws:iot:*:*:rolealias/panorama*"
            ]
        }
    ]
}
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "panorama.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```