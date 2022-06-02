# Automate application deployment<a name="api-deploy"></a>

To deploy an application, you use both the AWS Panorama Application CLI and AWS Command Line Interface\. After building the application container, you upload it and other assets to an Amazon S3 access point\. You then deploy the application with the [CreateApplicationInstance](https://docs.aws.amazon.com/panorama/latest/api/API_CreateApplicationInstance.html) API\.

For more context and instructions for using the scripts shown, follow the instructions in the [sample application README](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/README.md)\.

**Topics**
+ [Build the container](#api-deploy-build)
+ [Upload the container and register nodes](#api-deploy-upload)
+ [Deploy the application](#api-deploy-deploy)
+ [Monitor the deployment](#api-deploy-monitor)

## Build the container<a name="api-deploy-build"></a>

To build the application container, use the `build-container` command\. This command builds a Docker container and saves it as a compressed file system in the `assets` folder\.

**Example [3\-build\-container\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/3-build-container.sh)**  

```
CODE_PACKAGE=SAMPLE_CODE
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
panorama-cli build-container --container-asset-name code_asset --package-path packages/${ACCOUNT_ID}-${CODE_PACKAGE}-1.0
```

You can also use command\-line completion to fill in the path argument by typing part of the path, and then pressing TAB\.

```
$ panorama-cli build-container --package-path packages/TAB
```

## Upload the container and register nodes<a name="api-deploy-upload"></a>

To upload the application, use the `package-application` command\. This command uploads assets from the `assets` folder to an Amazon S3 access point that AWS Panorama manages\.

**Example [4\-package\-app\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/4-package.sh)**  

```
panorama-cli package-application
```

 The AWS Panorama Application CLI uploads container and descriptor assets referenced by package manifests \(`package.json`\) in each package, and registers the packages as nodes in AWS Panorama\. You then refer to these nodes in your application manifest \(`graph.json`\) to deploy the application\.

## Deploy the application<a name="api-deploy-deploy"></a>

To deploy the application, you use the [CreateApplicationInstance](https://docs.aws.amazon.com/panorama/latest/api/API_CreateApplicationInstance.html) API\. This action takes the following parameters, among others\.

****
+ `ManifestPayload` – The application manifest \(`graph.json`\) that defines the application's nodes, packages, edges, and parameters\.
+ `ManifestOverridesPayload` – A second manifest that overrides parameters in the first\. The application manifest can be considered as a static resource in the application source, where the override manifest provides deploy\-time settings that customize the deployment\.
+ `DefaultRuntimeContextDevice` – The target device\.
+ `RuntimeRoleArn` – The ARN of an IAM role that the application uses to access AWS services and resources\.
+ `ApplicationInstanceIdToReplace` – The ID of an existing application instance to remove from the device\.

The manifest and override payloads are JSON documents that must be provided as a string value nested inside of another document\. To do this, the script loads the manifests from a file as a string and uses the [jq tool](https://stedolan.github.io/jq/) to construct the nested document\.

**Example [5\-deploy\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/5-deploy.sh) – compose manifests**  

```
GRAPH_PATH="graphs/my-app/graph.json"
OVERRIDE_PATH="graphs/my-app/override.json"
# application manifest
GRAPH=$(cat ${GRAPH_PATH} | tr -d '\n' | tr -d '[:blank:]')
MANIFEST="$(jq --arg value "${GRAPH}" '.PayloadData="\($value)"' <<< {})"
# manifest override
OVERRIDE=$(cat ${OVERRIDE_PATH} | tr -d '\n' | tr -d '[:blank:]')
MANIFEST_OVERRIDE="$(jq --arg value "${OVERRIDE}" '.PayloadData="\($value)"' <<< {})"
```

The deploy script uses the [ListDevices](https://docs.aws.amazon.com/panorama/latest/api/API_ListDevices.html) API to get a list of registered devices in the current Region, and saves the users choice to a local file for subsequent deployments\.

**Example [5\-deploy\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/5-deploy.sh) – find a device**  

```
    echo "Getting devices..."
    DEVICES=$(aws panorama list-devices)
    DEVICE_NAMES=($((echo ${DEVICES} | jq -r '.Devices |=sort_by(.LastUpdatedTime) | [.Devices[].Name] | @sh') | tr -d \'\"))
    DEVICE_IDS=($((echo ${DEVICES} | jq -r '.Devices |=sort_by(.LastUpdatedTime) | [.Devices[].DeviceId] | @sh') | tr -d \'\"))
    for (( c=0; c<${#DEVICE_NAMES[@]}; c++ ))
    do
        echo "${c}: ${DEVICE_IDS[${c}]}     ${DEVICE_NAMES[${c}]}"
    done
    echo "Choose a device"
    read D_INDEX
    echo "Deploying to device ${DEVICE_IDS[${D_INDEX}]}"
    echo -n ${DEVICE_IDS[${D_INDEX}]} > device-id.txt
    DEVICE_ID=$(cat device-id.txt)
```

The application role is created by another script \([1\-create\-role\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/1-create-role.sh)\)\. The deploy script gets the ARN of this role from AWS CloudFormation\. If the application is already deployed to the device, the script gets the ID of that application instance from a local file\.

**Example [5\-deploy\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/5-deploy.sh) – role ARN and replacement arguments**  

```
# application role
STACK_NAME=panorama-${NAME}
ROLE_ARN=$(aws cloudformation describe-stacks --stack-name panorama-${PWD##*/} --query 'Stacks[0].Outputs[?OutputKey==`roleArn`].OutputValue' --output text)
ROLE_ARG="--runtime-role-arn=${ROLE_ARN}"

# existing application instance id
if [ -f "application-id.txt" ]; then
    EXISTING_APPLICATION=$(cat application-id.txt)
    REPLACE_ARG="--application-instance-id-to-replace=${EXISTING_APPLICATION}"
    echo "Replacing application instance ${EXISTING_APPLICATION}"
fi
```

Finally, the script puts all of the pieces together to create an application instance and deploy the application to the device\. The service responds with an instance ID which the script stores for later use\.

**Example [5\-deploy\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/5-deploy.sh) – deploy application**  

```
APPLICATION_ID=$(aws panorama create-application-instance ${REPLACE_ARG} --manifest-payload="${MANIFEST}" --default-runtime-context-device=${DEVICE_ID} --name=${NAME} --description="command-line deploy" --tags client=sample --manifest-overrides-payload="${MANIFEST_OVERRIDE}" ${ROLE_ARG} --output text)
echo "New application instance ${APPLICATION_ID}"
echo -n $APPLICATION_ID > application-id.txt
```

## Monitor the deployment<a name="api-deploy-monitor"></a>

To monitor a deployment, use the [ListApplicationInstances](https://docs.aws.amazon.com/panorama/latest/api/API_ListApplicationInstances.html) API\. The monitor script gets the device ID and application instance ID from files in the application directory and uses them to construct a CLI command\. It then calls in a loop\.

**Example [6\-monitor\-deployment\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/6-monitor-deployment.sh)**  

```
APPLICATION_ID=$(cat application-id.txt)
DEVICE_ID=$(cat device-id.txt)
QUERY="ApplicationInstances[?ApplicationInstanceId==\`APPLICATION_ID\`]"
QUERY=${QUERY/APPLICATION_ID/$APPLICATION_ID}
MONITOR_CMD="aws panorama list-application-instances --device-id ${DEVICE_ID} --query ${QUERY}"
MONITOR_CMD=${MONITOR_CMD/QUERY/$QUERY}
while true; do
    $MONITOR_CMD
    sleep 60
done
```

When the deployment completes, you can view logs by calling the Amazon CloudWatch Logs API\. The view logs script uses the CloudWatch Logs `GetLogEvents` API\.

**Example [view\-logs\.sh](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/util-scripts/view-logs.sh)**  

```
GROUP="/aws/panorama/devices/MY_DEVICE_ID/applications/MY_APPLICATION_ID"
GROUP=${GROUP/MY_DEVICE_ID/$DEVICE_ID}
GROUP=${GROUP/MY_APPLICATION_ID/$APPLICATION_ID}
echo "Getting logs for group ${GROUP}."
#set -x
while true
do
    LOGS=$(aws logs get-log-events --log-group-name ${GROUP} --log-stream-name code_node --limit 150)
    readarray -t ENTRIES < <(echo $LOGS | jq -c '.events[].message')
    for ENTRY in "${ENTRIES[@]}"; do
        echo "$ENTRY" | tr -d \"
    done
    sleep 20
done
```