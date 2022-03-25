# Setup scripts

Run these scripts from any directory.

## provision-device.sh

Provision a device.

    $ ./provision-device.sh <device-name>

## register-camera.sh

Register a camera.

    $ ./register-camera.sh <stream-name> <username> <rtsp-url>

## deregister-camera.sh

Delete a camera node.

    $ ./deregister-camera.sh <node-name>

# Application scripts

Copy these scripts into a sample app directory, or an application adapted from a sample app. 

## push.sh

Build, upload, and deploy and application.

    my-app$ ./push.sh

Upload and deploy only (configuration changes).

    my-app$ ./push.sh package

Deploy only (manifest changes)

    my-app$ ./push.sh deploy

## rename-package.sh

Rename a node package. Updates directory names, configuration files, and the application manifest.

    my-app$ ./rename-package.sh <old-name> <new-name>

## samplify.sh

Replace your account ID with an example account ID, and restore backup configurations to remove local configuration. Before use, update the script with the package names for your application (`CODE_PACKAGE` and `MODEL_PACKAGE`).

    my-app$ ./samplify.sh

## update-model-config.sh

Re-add the model to the application after updating the descriptor file. Before use, update the `MODEL_ASSET` and `MODEL_PACKAGE` variables in the script.

    my-app$ ./update-model-config.sh

## view-logs.sh

View logs for the current application instance (from `application-id.txt`).

    my-app$ ./view-logs.sh
