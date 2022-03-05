#!/bin/bash
set -eo pipefail
MODEL_URI=$(cat model-uri.txt)
echo "MODEL OBJECT URI"
echo $MODEL_URI
aws s3 cp $MODEL_URI .