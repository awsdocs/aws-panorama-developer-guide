# Package configuration<a name="applications-packages"></a>

When you use the AWS Panorama Application CLI command `panorama-cli package-application`, the CLI uploads your application's assets to Amazon S3 and registers them with AWS Panorama\. Assets include binary files \(container images and models\) and descriptor files, which the AWS Panorama Appliance downloads during deployment\. To register a package's assets, you provide a separate package configuration file that defines the package, its assets, and its interface\.

The following example shows a package configuration for a code node with one input and one output\. The video input provides access to image data from a camera stream\. The output node sends processed images out to a display\.

**Example packages/1234567890\-SAMPLE\_CODE\-1\.0/package\.json**  

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
                        "assetUri": "3d9bxmplbdb67a3c9730abb19e48d78780b507f3340ec3871201903d8805328a.tar.gz",
                        "descriptorUri": "1872xmpl129481ed053c52e66d6af8b030f9eb69b1168a29012f01c7034d7a8f.json"
                    }
                ]
            }
        ],
        "interfaces": [
            {
                "name": "interface",
                "category": "business_logic",
                "asset": "code_asset",
                "inputs": [
                    {
                        "name": "video_in",
                        "type": "media"
                    }
                ],
                "outputs": [
                    {
                        "description": "Video stream output",
                        "name": "video_out",
                        "type": "media"
                    }
                ]
            }
        ]
    }
}
```

The `assets` section specifies the names of artifacts that the AWS Panorama Application CLI uploaded to Amazon S3\. If you import a sample application or an application from another user, this section can be empty or refer to assets that aren't in your account\. When you run `panorama-cli package-application`, the AWS Panorama Application CLI populates this section with the correct values\.