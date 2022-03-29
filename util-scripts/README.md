# Setup scripts

Run these scripts from any directory.

## provision-device.sh

Provision a device.

    $ ./provision-device.sh <device-name>

## register-camera.sh

Register a camera.

    $ ./register-camera.sh <stream-name> <username> <rtsp-url>

    $ ./register-camera.sh exterior-north admin rtsp://10.11.12.13/mpeg4
    Enter camera stream password: 

## cleanup-patches.sh

Deregister old patch versions and delete their manifests from Amazon S3.

    $ ./cleanup-patches.sh <package-name>

    $ ./cleanup-patches.sh SAMPLE_CODE
    PATCH VERSIONS
    2021-10-27T05:48:54.000Z : Version 1.0.7dc1xmplbfc29dfeef1db50a614d29cf5c76fa465362d5c9780dbb2033f9df8a
    2021-11-08T23:37:08.000Z : Version 1.0.0accxmplc299e19518661718f8f3e83511fca8db43e9e8eac72932203872a747
    2021-12-27T22:22:08.000Z : Version 1.0.5446xmpl22b8aa076c2d7c69dfff8b80680a55d79c562ee01da6cf46d7ac9716
    Deregister how many old versions?

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

    my-app$ ./rename-package.sh SAMPLE_CODE ASSEMBLY_LINE

## samplify.sh

Replace your account ID with an example account ID, and restore backup configurations to remove local configuration. Before use, update the script with the package names for your application (`CODE_PACKAGE` and `MODEL_PACKAGE`).

    my-app$ ./samplify.sh

## update-model-config.sh

Re-add the model to the application after updating the descriptor file. Before use, update the `MODEL_ASSET` and `MODEL_PACKAGE` variables in the script.

    my-app$ ./update-model-config.sh

## view-logs.sh

View logs for the current application instance (from `application-id.txt`).

    my-app$ ./view-logs.sh

View logs for a specific device ID and application instance ID.

    $ ./view-logs.sh <device-id> <application-instance-id>

    $ ./view-logs.sh device-qs76xmplkzhlggieuh3ra4luxm applicationInstance-yk76xmplh4vvqvl2ne2k4vkrme