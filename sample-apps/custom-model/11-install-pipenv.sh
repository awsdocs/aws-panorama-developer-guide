#!/bin/bash
set -eo pipefail
PROJECT=${PWD##*/}
pip install --upgrade pip pipenv
pipenv install
