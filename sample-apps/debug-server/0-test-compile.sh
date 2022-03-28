#!/bin/bash
set -eo pipefail
CODE_PACKAGE=DEBUG_SERVER
python3 -m py_compile packages/*-${CODE_PACKAGE}-1.0/application.py
echo "Compilation successful"
