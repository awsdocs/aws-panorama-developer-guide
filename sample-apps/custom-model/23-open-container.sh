#!/bin/bash
set -eo pipefail
docker run --gpus all -it --rm -v /home/ubuntu/custom-model:/workspace panorama-custom-model /bin/bash
