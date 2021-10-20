# AWS Panorama Developer Guide

-----
*****Copyright &copy; Amazon Web Services, Inc. and/or its affiliates. All rights reserved.*****

-----
Amazon's trademarks and trade dress may not be used in 
     connection with any product or service that is not Amazon's, 
     in any manner that is likely to cause confusion among customers, 
     or in any manner that disparages or discredits Amazon. All other 
     trademarks not owned by Amazon are the property of their respective
     owners, who may or may not be affiliated with, connected to, or 
     sponsored by Amazon.

-----
## Contents
+ [What is AWS Panorama?](panorama-welcome.md)
+ [Getting started with AWS Panorama](panorama-gettingstarted.md)
   + [AWS Panorama concepts](gettingstarted-concepts.md)
   + [Setting up the AWS Panorama Appliance](gettingstarted-setup.md)
   + [Deploying the AWS Panorama sample application](gettingstarted-deploy.md)
   + [Developing AWS Panorama applications](gettingstarted-sample.md)
   + [Supported computer vision models and cameras](gettingstarted-compatibility.md)
   + [AWS Panorama Appliance specifications](gettingstarted-hardware.md)
+ [AWS Panorama permissions](panorama-permissions.md)
   + [Identity-based IAM policies for AWS Panorama](permissions-user.md)
   + [AWS Panorama service roles and cross-service resources](permissions-services.md)
   + [Granting permissions to an application](permissions-application.md)
+ [Managing the AWS Panorama Appliance](panorama-appliance.md)
   + [Managing an AWS Panorama Appliance](appliance-manage.md)
   + [Managing camera streams in AWS Panorama](appliance-cameras.md)
   + [Manage applications on an AWS Panorama Appliance](appliance-applications.md)
   + [AWS Panorama Appliance buttons and lights](appliance-buttons.md)
+ [Building AWS Panorama applications](panorama-applications.md)
   + [Managing applications in AWS Panorama](applications-manage.md)
   + [The application manifest](applications-manifest.md)
   + [Computer vision models](applications-models.md)
   + [Calling AWS services from your application code](applications-awssdk.md)
   + [Adding text and boxes to output video](applications-overlays.md)
   + [The AWS Panorama Application SDK](applications-panoramasdk.md)
+ [Monitoring AWS Panorama resources and applications](panorama-monitoring.md)
   + [Monitoring in the AWS Panorama console](monitoring-console.md)
   + [Viewing AWS Panorama event logs in CloudWatch Logs](monitoring-logging.md)
+ [Troubleshooting](panorama-troubleshooting.md)
+ [Security in AWS Panorama](panorama-security.md)
   + [Data protection in AWS Panorama](security-dataprotection.md)
   + [Identity and access management for AWS Panorama](security-iam.md)
      + [How AWS Panorama works with IAM](security_iam_service-with-iam.md)
      + [AWS Panorama identity-based policy examples](security_iam_id-based-policy-examples.md)
      + [AWS managed policies for AWS Panorama](security-iam-awsmanpol.md)
      + [Using service-linked roles for AWS Panorama](using-service-linked-roles.md)
      + [Cross-service confused deputy prevention](security-iam-trustpolicies.md)
      + [Troubleshooting AWS Panorama identity and access](security_iam_troubleshoot.md)
   + [Compliance validation for AWS Panorama](security-compliance.md)
   + [Infrastructure security in AWS Panorama](security-infrastructure.md)
   + [Runtime environment software in AWS Panorama](security-runtime.md)
+ [Releases](panorama-releases.md)