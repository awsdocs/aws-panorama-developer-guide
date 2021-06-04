import unittest
import importlib
import logging
import json
import tensorflow as tf
import boto3
from inspect import getmembers, isfunction

from model.model import Model
logger = logging.getLogger()

# aws clients
cfn_client = boto3.client('cloudformation')

class TestFunction(unittest.TestCase):

    def setUp(self):
        stack = cfn_client.describe_stacks(
            StackName='panorama-custom-model'
        )
        resources = {output['OutputKey']: output['OutputValue'] for output in stack['Stacks'][0]['Outputs']}
        self.SERVICE_ROLE_ARN=resources['roleArn']
        self.BUCKET_NAME=resources['bucketName']

    def test_function(self):
        #model_names = [model[0] for model in getmembers(tf.keras.applications, isfunction)]
        #model_names = ['ResNet50V2']
        #model_names = ['MobileNetV2']
        model_names = ['DenseNet121']
        compilation_jobs = {}
        packaging_jobs = {}

        for model_name in model_names:
            model = Model(self.BUCKET_NAME, self.SERVICE_ROLE_ARN)
            model_class = getattr(tf.keras.applications, model_name)
            model_uri, model_input_name, model_input_shape = model.export_model(model_class)

            input_name = model_input.get('name')
            job = model.compile_model(model_uri,model_input_name,model_input_shape)
            logger.info('Input name: {}'.format(model_input_name))
            logger.info('Input shape: {}'.format(model_input_shape))
            compilation_jobs[model_name] = job

        for _, model_name in enumerate(compilation_jobs):
            with self.subTest(model=model_name):
                compilation_job = compilation_jobs.get(model_name)
                result = model.wait_compilation(compilation_job)
                logger.info('Compilation result: {}'.format(result))
                if result[1] == 'Success':
                    job = model.package_model(model_name, compilation_job)
                    packaging_jobs[model_name] = job
                self.assertRegex(str(result), 'Success', 'Should match')

        for _, model_name in enumerate(packaging_jobs):
            with self.subTest(model=model_name):
                packaging_job = packaging_jobs.get(model_name)
                result = model.wait_packaging(packaging_job)
                logger.info('Packaging result: {}'.format(result))
                self.assertRegex(str(result), 'Success', 'Should match')

if __name__ == '__main__':
    unittest.main()