# Using VPC endpoints<a name="api-endpoints"></a>

If you work in a VPC without internet access, you can create a [VPC endpoint](#services-vpc-interface) for use with AWS Panorama\. A VPC endpoint lets clients running in a private subnet connect to an AWS service without an internet connection\.

## Creating a VPC endpoint<a name="services-vpc-interface"></a>

To establish a private connection between your VPC and AWS Panorama, create a *VPC endpoint*\. A VPC endpoint is not required to use AWS Panorama\. You only need to create a VPC endpoint if you work in a VPC without internet access\. When the AWS CLI or SDK attempts to connect to AWS Panorama, the traffic is routed through the VPC endpoint\.

[Create a VPC endpoint](https://console.aws.amazon.com//vpc/home#CreateVpcEndpoint:) for AWS Panorama using the following settings:
+ **Service name** – **com\.amazonaws\.*us\-west\-2*\.panorama**
+ **Type** – **Interface**

A VPC endpoint uses the service's DNS name to get traffic from AWS SDK clients without any additional configuration\. For more information about using VPC endpoints, see [Interface VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpce-interface.html) in the *Amazon VPC User Guide*\.

## Connecting an appliance to a private subnet<a name="services-vpc-appliance"></a>

The AWS Panorama Appliance can connect to AWS over a private VPN connection with AWS Site\-to\-Site VPN or AWS Direct Connect\. With these services, you can create a private subnet that extends to your data center\. The appliance connects to the private subnet and accesses AWS services through VPC endpoints\.

Site\-to\-Site VPN and AWS Direct Connect are services for connecting your data center to Amazon VPC securely\. With Site\-to\-Site VPN, you can use commercially available network devices to connect\. AWS Direct Connect uses an AWS device to connect\.

****
+ **Site\-to\-Site VPN** – [What is AWS Site\-to\-Site VPN?](https://docs.aws.amazon.com/vpn/latest/s2svpn/)
+ **AWS Direct Connect** – [What is AWS Direct Connect?](https://docs.aws.amazon.com/directconnect/latest/UserGuide/)

After you've connected your local network to a private subnet in a VPC, create VPC endpoints for the following services\.

****
+ **Amazon Simple Storage Service** – [AWS PrivateLink for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/privatelink-interface-endpoints.html)
+ **AWS IoT** – [Using AWS IoT Core with interface VPC endpoints](https://docs.aws.amazon.com/iot/latest/developerguide/IoTCore-VPC.html)
+ **Amazon CloudWatch** – [Using CloudWatch with interface VPC endpoints ](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-and-interface-VPC.html)
+ **Amazon CloudWatch Logs** – [Using CloudWatch Logs with interface VPC endpoints](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/cloudwatch-logs-and-interface-VPC.html)

The appliance does not need connectivity to the AWS Panorama service\. It communicates with AWS Panorama through a messaging channel in AWS IoT\.

In addition to VPC endpoints, Amazon S3 and AWS IoT require the use of Amazon Route 53 private hosted zones\. The private hosted zone routes traffic from subdomains, including subdomains for Amazon S3 access points and MQTT topics, to the correct VPC endpoint\. For information on private hosted zones, see [Working with private hosted zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html) in the Amazon Route 53 Developer Guide\.

For a sample VPC configuration with VPC endpoints and private hosted zones, see [Sample AWS CloudFormation templates](#services-vpc-templates)\.

## Sample AWS CloudFormation templates<a name="services-vpc-templates"></a>

The GitHub repository for this guide provides AWS CloudFormation templates that you can use to create resources for use with AWS Panorama\. The templates create a VPC with two private subnets, a public subnet, and a VPC endpoint\. You can use the private subnets in the VPC to host resources that are isolated from the internet\. Resources in the public subnet can communicate with the private resources, but the private resources can't be accessed from the internet\.

**Example [vpc\-endpoint\.yml](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/cloudformation-templates/vpc-endpoint.yml) – Private subnets**  

```
AWSTemplateFormatVersion: 2010-09-09
Resources:
  vpc:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 172.31.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Ref AWS::StackName
  privateSubnetA:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref vpc
      AvailabilityZone:
        Fn::Select:
         - 0
         - Fn::GetAZs: ""
      CidrBlock: 172.31.3.0/24
      MapPublicIpOnLaunch: false
      Tags:
        - Key: Name
          Value: !Sub  ${AWS::StackName}-subnet-a
  ...
```

The `vpc-endpoint.yml` template shows how to create a VPC endpoint for AWS Panorama\. You can use this endpoint to manage AWS Panorama resources with the AWS SDK or AWS CLI\.

**Example [vpc\-endpoint\.yml](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/cloudformation-templates/vpc-endpoint.yml) – VPC endpoint**  

```
  panoramaEndpoint:
    Type: AWS::EC2::VPCEndpoint
    Properties:
      ServiceName: !Sub com.amazonaws.${AWS::Region}.panorama
      VpcId: !Ref vpc
      VpcEndpointType: Interface
      SecurityGroupIds:
      - !GetAtt vpc.DefaultSecurityGroup
      PrivateDnsEnabled: true
      SubnetIds:
      - !Ref privateSubnetA
      - !Ref privateSubnetB
      PolicyDocument:
        Version: 2012-10-17
        Statement:
        - Effect: Allow
          Principal: "*"
          Action:
            - "panorama:*"
          Resource:
            - "*"
```

The `PolicyDocument` is a resource\-based permissions policy that defines the API calls that can be made with the endpoint\. You can modify the policy to restrict the actions and resources that can be accessed through the endpoint\. For more information, see [Controlling access to services with VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints-access.html) in the *Amazon VPC User Guide*\. 

The `vpc-appliance.yml` template shows how to create VPC endpoints and private hosted zones for services used by the AWS Panorama Appliance\.

**Example [vpc\-appliance\.yml](https://github.com/awsdocs/aws-panorama-developer-guide/blob/main/cloudformation-templates/vpc-appliance.yml) – Amazon S3 access point endpoint with private hosted zone**  

```
  s3Endpoint:
    Type: AWS::EC2::VPCEndpoint
    Properties:
      ServiceName: !Sub com.amazonaws.${AWS::Region}.s3
      VpcId: !Ref vpc
      VpcEndpointType: Interface
      SecurityGroupIds:
      - !GetAtt vpc.DefaultSecurityGroup
      PrivateDnsEnabled: false
      SubnetIds:
      - !Ref privateSubnetA
      - !Ref privateSubnetB
...
  s3apHostedZone:
    Type: AWS::Route53::HostedZone
    Properties:
      Name: !Sub s3-accesspoint.${AWS::Region}.amazonaws.com
      VPCs: 
        - VPCId: !Ref vpc
          VPCRegion: !Ref AWS::Region
  s3apRecords:
    Type: AWS::Route53::RecordSet
    Properties:
      HostedZoneId: !Ref s3apHostedZone
      Name: !Sub "*.s3-accesspoint.${AWS::Region}.amazonaws.com"
      Type: CNAME
      TTL: 600
      # first DNS entry, split on :, second value
      ResourceRecords: 
      - !Select [1, !Split [":", !Select [0, !GetAtt s3Endpoint.DnsEntries ] ] ]
```

The sample templates demonstrate the creation of Amazon VPC and Route 53 resources with a sample VPC\. You can adapt these for your use case by removing the VPC resources and replacing the references to subnet, security group, and VPC IDs with the IDs of your resources\.