# Create CloudFormation Stack
echo "Creating CloudFormation Stack"
aws cloudformation create-stack --stack-name $1 --template-body file://./stack.json

aws cloudformation validate-template --template-body file://./stack.json
