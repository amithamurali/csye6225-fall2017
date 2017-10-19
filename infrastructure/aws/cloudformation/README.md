Team member information such as Name and Email address.

Amitha_Murali, 001643826, murali.a@husky.neu.edu 
Jyoti Sharma, 001643410, sharma.j@husky.neu.edu 
Surabhi Patil, 001251860, patil.sur@husky.neu.edu

Cloud Formation:

Prerequisites 
 * AWS CLI
 * AWS account (Route53, IAM, CloudFormation, EC2)
 
Run commands:
Open terminal and run the following commands 

1. To launch : sh create-csye6225-cloudformation-stack.sh 'stackname' where stackname needs to be passed through the command line.
2. To terminate : sh delete-csye6225-cloudformation-stack.sh 'stackname' where stackname needs to be passed through the command line.

Objective:

Create a CloudFormation stack that contains following resources:

1) Create and configure security group for EC2 Instance
2) Launch EC2 Instance and wait for EC2 instance to be in running state.
3) Retrieve instance’s public IP address.
4) Add/Update type A resource record set ec2.YOUR_DOMAIN_NAME.me in the Route 53 zone for your domain with the IP of the newly launched EC2 instance. TTL for the resource record set should be set to 60 seconds.
5) Create and configure security group for RDS instance.
6) Add Ingress rule to security group to allow traffic.
7) Create a DynamoDB table with provided configuration.
8) Create a S3 bucket with customized bucket name.
9) Create 2 subnets in existing vpc.
10) Create a DB subnet group.
11) Launch RDS instance.

Validate output: 
check if the security group, ec2 instance and resource records were successfully created with the mentioned parameters and later deleted through the delete script. Check the RDS instance , S3 bucket and dynamo db table.



