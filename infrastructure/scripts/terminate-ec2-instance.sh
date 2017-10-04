echo "Deleting a Record Set"

aws route53 change-resource-record-sets --hosted-zone-id Z2DH59WEOS3S7Z --change-batch file://./jsondeleterecordset.json

echo "Terminating ec2 instance"

#Disable the protection against termination.
#aws ec2 modify-instance-attribute --instance-id $1 --disable-api-termination

#Terminate the ec2 instance
aws ec2 terminate-instances --instance-ids $1

sleep 15s

echo "Deleting Security Group"
# Deleting Your Security Group
aws ec2 delete-security-group --group-name csye6225-fall2017-webapp
