# Building an application image<a name="applications-image"></a>

The AWS Panorama Appliance runs applications as container filesystems exported from an image that you build\. You specify your application's dependencies and resources in a Dockerfile that uses the AWS Panorama application base image as a starting point\.

To build an application image, you use Docker and the AWS Panorama Application CLI\. The following example from this guide's sample application demonstrates these use cases\.

**Example [packages/123456789012\-SAMPLE\_CODE\-1\.0/Dockerfile](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/Dockerfile)**  

```
FROM public.ecr.aws/panorama/panorama-application
WORKDIR /panorama
COPY . .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
```

The following Dockerfile instructions are used\.

****
+ `FROM` – Loads the application base image \(`public.ecr.aws/panorama/panorama-application`\)\. 
+ `WORKDIR` – Set the working directory on the image\. `/panorama` is used for application code and related files\. This setting only persists during the build and does not affect the working directory for your application at runtime \(`/`\)\.
+ `COPY` – Copies files from a local path to a path on the image\. `COPY . .` copies the files in the current directory \(the package directory\) to the working directory on the image\. For example, the application code is copied from `packages/123456789012-SAMPLE_CODE-1.0/application.py` to `/panorama/application.py`\.
+ `RUN` – Runs shell commands on the image during the build\. A single `RUN` operation can run multiple commands in sequence by using `&&` between commands\. This example updates the `pip` package manager and then installs the libraries listed in `requirements.txt`\.

You can use other instructions, such as `ADD` and `ARG`, that are useful at build time\. Instructions that add runtime information to the container, such as `ENV`, do not work with AWS Panorama\. AWS Panorama does not run a container from the image\. It only uses the image to export a filesystem, which is transferred to the appliance\.

## Specifying dependencies<a name="applications-image-dependencies"></a>

`requirements.txt` is a Python requirements file that specifies libraries used by the application\. The sample application uses Open CV and the AWS SDK for Python \(Boto3\)\.

**Example [packages/123456789012\-SAMPLE\_CODE\-1\.0/requirements\.txt](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/requirements.txt)**  

```
boto3==1.24.*
opencv-python==4.6.*
```

The `pip install` command in the Dockerfile installs these libraries to the Python `dist-packages` directory under `/usr/local/lib`, so that they can be imported by your application code\.

## Building image assets<a name="applications-image-build"></a>

When you build a image for your application package with the AWS Panorama Application CLI, the CLI runs `docker build` in the package directory\. This builds an application image that contains your application code\. The CLI then creates a container, exports its filesystem, compresses it, and stores it in the `assets` folder\.

```
$ panorama-cli build-container --container-asset-name code_asset --package-path packages/123456789012-SAMPLE_CODE-1.0
docker build -t code_asset packages/123456789012-SAMPLE_CODE-1.0 --pull
docker export --output=code_asset.tar $(docker create code_asset:latest)
gzip -1 code_asset.tar
{
    "name": "code_asset",
    "implementations": [
        {
            "type": "container",
            "assetUri": "6f67xmpl32743ed0e60c151a02f2f0da1bf70a4ab9d83fe236fa32a6f9b9f808.tar.gz",
            "descriptorUri": "1872xmpl129481ed053c52e66d6af8b030f9eb69b1168a29012f01c7034d7a8f.json"
        }
    ]
}
Container asset for the package has been succesfully built at  /home/user/aws-panorama-developer-guide/sample-apps/aws-panorama-sample/assets/6f67xmpl32743ed0e60c151a02f2f0da1bf70a4ab9d83fe236fa32a6f9b9f808.tar.gz
```

The JSON block in the output is an asset definition that the CLI adds to the package manifest \(`package.json`\) and registers with the AWS Panorama service\. The CLI also copies the descriptor file, which specifies the path to the application script \(the application's entry point\)\.

**Example [packages/123456789012\-SAMPLE\_CODE\-1\.0/descriptor\.json](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/packages/123456789012-SAMPLE_CODE-1.0/descriptor.json)**  

```
{
    "runtimeDescriptor":
    {
        "envelopeVersion": "2021-01-01",
        "entry":
        {
            "path": "python3",
            "name": "/panorama/application.py"
        }
    }
}
```

In the assets folder, the descriptor and application image are named for their SHA\-256 checksum\. This name is used as a unique identifier for the asset when it is stored is Amazon S3\. 