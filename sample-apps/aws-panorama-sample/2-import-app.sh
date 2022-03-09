#!/bin/bash
set -eo pipefail
# download sample model
echo "Downloading sample model"
curl --location https://github.com/awsdocs/aws-panorama-developer-guide/releases/download/v1.0-ga/fd1aef48acc3350a5c2673adacffab06af54c3f14da6fe4a8be24cac687a386e.tar.gz -o assets/fd1aef48acc3350a5c2673adacffab06af54c3f14da6fe4a8be24cac687a386e.tar.gz
# rename directories
panorama-cli import-application
