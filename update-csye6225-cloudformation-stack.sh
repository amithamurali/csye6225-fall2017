# Update stack to disable ec2 termination protection
echo "Updating CloudFormation Stack to Disable EC2 termination protection"
aws cloudformation update-stack --stack-name $1 --template-body file://./updateStack.json
