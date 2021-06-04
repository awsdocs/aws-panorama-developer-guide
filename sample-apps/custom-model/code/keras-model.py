import importlib
import logging
import json
import tensorflow as tf
import boto3
import sys
from inspect import getmembers, isfunction

from model.model import Model
logger = logging.getLogger()
logger.setLevel(logging.INFO)
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s [%(levelname)s] %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)

cfn_client = boto3.client('cloudformation')

class KerasModel():

    def __init__(self):
        """Get service role and bucket name from CloudFormation stack outputs"""
        stack = cfn_client.describe_stacks(
            StackName='panorama-custom-model'
        )
        resources = {output['OutputKey']: output['OutputValue'] for output in stack['Stacks'][0]['Outputs']}
        self.SERVICE_ROLE_ARN=resources['roleArn']
        self.BUCKET_NAME=resources['bucketName']
        logger.info('Service role: {}'.format(self.SERVICE_ROLE_ARN))
        logger.info('Bucket: {}'.format(self.BUCKET_NAME))

    def compile(self, model_name='DenseNet121'):
        """Compile a Keras application model"""
        #model_names = [model[0] for model in getmembers(tf.keras.applications, isfunction)]
        compilation_jobs = {}
        packaging_jobs = {}
        # Export model
        model = Model(self.BUCKET_NAME, self.SERVICE_ROLE_ARN)
        model_class = getattr(tf.keras.applications, model_name)
        model_uri, model_input_name, model_input_shape = model.export_model(model_class)
        # Compile model
        compilation_job = model.compile_model(model_uri,model_input_name,model_input_shape)
        logger.info('Input name: {}'.format(model_input_name))
        logger.info('Input shape: {}'.format(model_input_shape))
        with open('model-uri.txt', 'w') as f:
            f.write(model_uri)
        # Package model
        result = model.wait_compilation(compilation_job)
        logger.info('Compilation result: {}'.format(result))
        if result[1] == 'Success':
            packaging_job = model.package_model(model_name, compilation_job)
        else:
            return 'Compilation failed'
        result = model.wait_packaging(packaging_job)
        logger.info('Packaging result: {}'.format(result))
        

if __name__ == '__main__':
    model = KerasModel()
    if len(sys.argv) == 1:
        model.compile()
    if len(sys.argv) == 2:
        model.compile(sys.argv[1])
