#!/bin/bash

#Surabhi Patil, 001251860, patil.sur@husky.neu.edu
#Amitha Murali, 001643826, murali.a@husky.neu.edu
#Jyoti Sharma, 001643410, sharma.j@husky.neu.edu
# Create CloudFormation Stack
echo "Creating CloudFormation Stack"

aws cloudformation create-stack --stack-name CodeDeployDemoStack --template-url http://s3.amazonaws.com/aws-codedeploy-us-east-1/templates/latest/CodeDeploy_SampleCF_Template.json --parameters ParameterKey=InstanceCount,ParameterValue=1 ParameterKey=InstanceType,ParameterValue=t1.micro --ParameterKey=KeyPairName,ParameterValue=ec2Key ParameterKey=OperatingSystem,ParameterValue=Linux -ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0 ParameterKey=TagKey,ParameterValue=Name --ParameterKey=TagValue,ParameterValue=CodeDeployDemo --capabilities CAPABILITY_IAM

aws cloudformation update-stack --stack-name CodeDeployDemoStack --template-body file://./updateStack1.json --capabilities CAPABILITY_IAM
