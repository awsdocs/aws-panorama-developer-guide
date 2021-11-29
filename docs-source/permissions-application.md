# Granting permissions to an application<a name="permissions-application"></a>

You can create a role for your application to grant it permission to call AWS services\. By default, applications do not have any permissions\. You create an application role in IAM and assign it to an application during deployment\. To grant your application only the permissions that it needs, create a role for it with permissions for specific API actions\.

The [sample application](gettingstarted-sample.md) includes an AWS CloudFormation template and script that create an application role\. It is a [service role](permissions-services.md) that AWS Panorama can assume\. This role grants permission for the application to call CloudWatch to upload metrics\.

**Example [aws\-panorama\-sample\.yml](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/sample-apps/aws-panorama-sample/aws-panorama-sample.yml) – Application role**  

```
Resources:
  runtimeRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          -
            Effect: Allow
            Principal:
              Service:
                - panorama.amazonaws.com
            Action:
              - sts:AssumeRole
      Policies:
        - PolicyName: cloudwatch-putmetrics
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action: 'cloudwatch:PutMetricData'
                Resource: '*'
      Path: /service-role/
```

You can extend this script to grant permissions to other services, by specifying a list of API actions or patterns for the value of `Action`\.

For more information on permissions in AWS Panorama, see [AWS Panorama permissions](panorama-permissions.md)\.