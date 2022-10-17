#!/usr/bin/env bash
set -eo pipefail
if [[ $# -eq 1 ]] ; then
    if [[ $1 == "deploy" ]] ; then
        DEPLOY_ONLY=true
        echo "Skipping compilation and packaging"
    fi
    if [[ $1 == "package" ]] ; then
        PACKAGE_DEPLOY=true
        echo "Skipping compilation"
    fi
fi
if [ -f "device-id.txt" ]; then
    DEVICE_ID=$(cat device-id.txt)
fi
./0-test-compile.sh
if [[ $PACKAGE_DEPLOY == true ]] ; then
    ./4-package-app.sh
elif [[ $DEPLOY_ONLY != true ]] ; then
    ./3-build-container.sh
    ./4-package-app.sh
fi
./5-deploy.sh
./6-monitor-deployment.sh
