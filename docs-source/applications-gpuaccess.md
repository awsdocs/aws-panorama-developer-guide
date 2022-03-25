# Using the GPU<a name="applications-gpuaccess"></a>

You can access the graphics processor \(GPU\) on the AWS Panorama Appliance to use GPU\-accelerated libraries, or run machine learning models in your application code\. To turn on GPU access, you add GPU access as a requirement to the package configuration after building your application code container\.

**Important**  
If you enable GPU access, you can't run model nodes in any application on the appliance\. For security purposes, GPU access is restricted when the appliance runs a model compiled with SageMaker Neo\. With GPU access, you must run your models in application code nodes, and all applications on the device share access to the GPU\.

To turn on GPU access for your application, update the [package manifest](applications-packages.md) after you build the package with the AWS Panorama Application CLI\. The following example shows the `requirements` block that adds GPU access to the application code node\.

**Example package\.json with requirements block**  

```
{
    "nodePackage": {
        "envelopeVersion": "2021-01-01",
        "name": "SAMPLE_CODE",
        "version": "1.0",
        "description": "Computer vision application code.",
        "assets": [
            {
                "name": "code_asset",
                "implementations": [
                    {
                        "type": "container",
                        "assetUri": "eba3xmpl71aa387e8f89be9a8c396416cdb80a717bb32103c957a8bf41440b12.tar.gz",
                        "descriptorUri": "4abdxmpl5a6f047d2b3047adde44704759d13f0126c00ed9b4309726f6bb43400ba9.json",
                        "requirements": [
                            {
                                "type": "hardware_access",
                                "inferenceAccelerators": [
                                    {
                                        "deviceType": "nvhost_gpu",
                                        "accessType": "open"
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        ],
        "interfaces": [
        ...
```

Update the package manifest between the build and packaging steps in your development workflow\.

**To deploy an application with GPU access**

1. To build the application container, use the `build-container` command\.

   ```
   $ panorama-cli build-container --container-asset-name code_asset --package-path packages/123456789012-SAMPLE_CODE-1.0
   ```

1. Add the `requirements` block to the package manifest\.

1. To upload the container asset and package manifest, use the `package-application` command\.

   ```
   $ panorama-cli package-application
   ```

1. Deploy the application\.

For sample applications that use GPU access, visit the [aws\-panorama\-samples](https://github.com/aws-samples/aws-panorama-samples) GitHub repository\.