# Automate device registration<a name="api-provision"></a>

To provision an appliance, use the [ProvisionDevice](https://docs.aws.amazon.com/panorama/latest/api/API_ProvisionDevice.html) API\. The response includes a ZIP file with the device's configuration and temporary credentials\. Decode the file and save it in an archive with the prefix `certificates-omni_`\.

**Example [provision\-device\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/provision-device.sh)**  

```
if [[ $# -eq 1 ]] ; then
    DEVICE_NAME=$1
else
    echo "Usage: ./provision-device.sh <device-name>"
    exit 1
fi
CERTIFICATE_BUNDLE=certificates-omni_${DEVICE_NAME}.zip
aws panorama provision-device --name ${DEVICE_NAME} --output text --query Certificates | base64 --decode > ${CERTIFICATE_BUNDLE}
echo "Created certificate bundle ${CERTIFICATE_BUNDLE}"
```

The credentials in the configuration archive expire after 5 minutes\. Transfer the archive to your appliance with the included USB drive\.

To register a camera, use the [CreateNodeFromTemplateJob](https://docs.aws.amazon.com/panorama/latest/api/API_CreateNodeFromTemplateJob.html) API\. This API takes a map of template parameters for the camera's username, password, and URL\. You can format this map as a JSON document by using Bash string manipulation\.

**Example [register\-camera\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/register-camera.sh)**  

```
if [[ $# -eq 3 ]] ; then
    NAME=$1
    USERNAME=$2
    URL=$3
else
    echo "Usage: ./register-camera.sh <stream-name> <username> <rtsp-url>"
    exit 1
fi
echo "Enter camera stream password: "
read PASSWORD
TEMPLATE='{"Username":"MY_USERNAME","Password":"MY_PASSWORD","StreamUrl": "MY_URL"}'
TEMPLATE=${TEMPLATE/MY_USERNAME/$USERNAME}
TEMPLATE=${TEMPLATE/MY_PASSWORD/$PASSWORD}
TEMPLATE=${TEMPLATE/MY_URL/$URL}
echo ${TEMPLATE}
JOB_ID=$(aws panorama create-node-from-template-job --template-type RTSP_CAMERA_STREAM --output-package-name ${NAME} --output-package-version "1.0" --node-name ${NAME} --template-parameters "${TEMPLATE}" --output text)
```

Alternatively, you can load the JSON configuration from a file\.

```
--template-parameters file://camera-template.json
```