import time
import os
import logging

import boto3
import os
from pathlib import Path
import shutil
import tensorflow as tf
import tarfile
import time
from inspect import getmembers, isfunction

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# aws clients
cfn_client = boto3.client('cloudformation')
s3_resource = boto3.resource('s3')
sagemaker_client=boto3.client('sagemaker')

class Model:

    def __init__(self, bucket_name, service_role_arn):
        """Saves the bucket name and service role ARN."""
        self.bucket_name = bucket_name
        self.service_role_arn = service_role_arn

    def export_model(self, model_class):
        """Exports a TensorFlow model in SavedModel format and uploads it to Amazon S3."""
        MODEL_NAME=model_class.__name__
        Path('/tmp/models').mkdir(exist_ok=True)
        MODEL_DIR='/tmp/models/{}'.format(MODEL_NAME)
        MODEL_KEY='models/{}-tf{}.tar.gz'.format(MODEL_NAME,tf.__version__.replace('.',''))
        MODEL_TAR='/tmp/{}'.format(MODEL_KEY)
        # Instantiate model
        model = model_class()
        # Get input layer details
        model_input=model.get_layer(index=0).get_config()
        model_input_name = model_input.get('name')
        _, w, h, c = model_input.get('batch_input_shape')
        # MobileNetV3 w and h default to null
        if not w:
            w = 224
            h = 224
        model_input_shape = '{},{},{}'.format(w,h,c)
        # Export model and create archive
        self.remove(MODEL_DIR)
        model.save(MODEL_DIR, save_format='tf')
        self.remove(MODEL_TAR)
        with tarfile.open(MODEL_TAR, mode='w:gz') as archive:
            archive.add(MODEL_DIR,MODEL_NAME)
        # Upload to Amazon S3
        model_uri = self.upload(self.bucket_name,MODEL_KEY,MODEL_TAR)
        return model_uri, model_input_name, model_input_shape

    def compile_model(self, s3_uri, input_name='input_1', input_shape='224,224,3', framework='TENSORFLOW', device='jetson_xavier'):
        """Compiles a model with Amazon Sagemaker Neo."""
        MODEL_INPUT_SHAPE = '{{"{}":[1,{}]}}'.format(input_name,input_shape)
        COMPILED_MODEL_FOLDER_URI = 's3://{}/models-compiled'.format(self.bucket_name)
        COMPILATION_JOB = 'panorama-custom-model-'+ str(time.time()).split('.')[0]
        logger.info('Compiling {}'.format(s3_uri))
        response = sagemaker_client.create_compilation_job(
                CompilationJobName=COMPILATION_JOB,
                RoleArn=self.service_role_arn,
                InputConfig={
                    'S3Uri': s3_uri,
                    'DataInputConfig': MODEL_INPUT_SHAPE,
                    'Framework': framework,
                    'FrameworkVersion': '2.4'
                },
                OutputConfig={
                    'S3OutputLocation': COMPILED_MODEL_FOLDER_URI,
                    'TargetDevice': device
                },
                StoppingCondition={
                    'MaxRuntimeInSeconds': 900
                }
            )
        logger.info(response)
        return COMPILATION_JOB

    def package_model(self, model_name, compilation_job):
        """Packages a model with Amazon Sagemaker Neo."""
        PACKAGING_JOB=compilation_job+'-packaging'
        MODEL_VERSION = '1.0'
        PACKAGED_MODEL_FOLDER_URI = 's3://{}/models-packaged'.format(self.bucket_name)
        response = sagemaker_client.create_edge_packaging_job(
            RoleArn=self.service_role_arn,
            OutputConfig={
                'S3OutputLocation': PACKAGED_MODEL_FOLDER_URI,
            },
            ModelName=model_name,
            ModelVersion=MODEL_VERSION,
            EdgePackagingJobName=PACKAGING_JOB,
            CompilationJobName=compilation_job,
        )
        logger.info(response)
        return PACKAGING_JOB

    def wait_compilation(self, job):
        """Waits for a Sagemaker Neo compilation job to complete."""
        while True:
            response = sagemaker_client.describe_compilation_job(CompilationJobName=job)
            if response['CompilationJobStatus'] == 'COMPLETED':
                return job, 'Success'
            elif response['CompilationJobStatus'] == 'FAILED':
                return job, 'Failed'
            logger.info('.')
            time.sleep(5)

    def wait_packaging(self, job):
        """Waits for a Sagemaker Neo packaging job to complete."""
        while True:
            response = sagemaker_client.describe_edge_packaging_job(EdgePackagingJobName=job)
            if response['EdgePackagingJobStatus'] == 'COMPLETED':
                return job, 'Success'
            elif response['EdgePackagingJobStatus'] == 'FAILED':
                return job, 'Failed'
            logger.info('.')
            time.sleep(5)

    def upload(self, bucket, key, src):
        """Uploads a file to Amazon S3."""
        uri = 's3://{}/{}'.format(bucket,key)
        s3_resource.Bucket(bucket).Object(key).upload_file(src)
        return uri

    def remove(self, path):
        """Removes a file or directory from /tmp."""
        if os.path.exists(path) and path.startswith('/tmp/') and len(path) > 5:
            if os.path.isfile(path) or os.path.islink(path):
                os.unlink(path)
            else:
                shutil.rmtree(path)