# Runtime environment software in AWS Panorama<a name="security-runtime"></a>

AWS Panorama provides software that runs your application code in an Ubuntu Linux–based environment on the AWS Panorama Appliance\. AWS Panorama is responsible for keeping software in the appliance image up to date\. AWS Panorama regularly releases software updates, which you can apply by [using the AWS Panorama console](appliance-manage.md#appliance-manage-software)\.

You can use libraries in your application code by installing them in the application's `Dockerfile`\. To ensure application stability across deployments, choose a specific version of each library\. Update your dependencies regularly to address security issues\.
