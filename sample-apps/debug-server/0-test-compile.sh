#!/bin/bash
set -eo pipefail
python3 -m py_compile packages/*-DEBUG_SERVER-1.0/application.py
echo "Compilation successful"
