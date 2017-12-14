************************ https://cloud.google.com/compute/docs/load-balancing/network/example *****************************************




## Create a project
gcloud projects create csye-6225-final-project --no-enable-cloud-apis
## Add a policy for another member
gcloud projects add-iam-policy-binding eternal-calling-183219 --member user:amitha.murali@gmail.com --role roles/editor

## Create three new virtual machines in a given zone and give them all the same tag
gcloud compute instances create csye-instance1 --zone us-east1-d --machine-type f1-micro --project csye-6225-final-project --tags mywebserver \
    --metadata startup-script="#! /bin/bash
      sudo apt-get update
      sudo apt-get install apache2 -y
      sudo service apache2 restart
      echo '<!doctype html><html><body><h1>csye-instance1</h1></body></html>' | tee /var/www/html/index.html
      EOF"

gcloud compute instances create csye-instance2 --zone us-east1-d --machine-type f1-micro --project csye-6225-final-project --tags mywebserver \
    --metadata startup-script="#! /bin/bash
      sudo apt-get update
      sudo apt-get install apache2 -y
      sudo service apache2 restart
      echo '<!doctype html><html><body><h1>csye-instance2</h1></body></html>' | tee /var/www/html/index.html
      EOF"

gcloud compute instances create csye-instance3 --zone us-east1-d --machine-type f1-micro --project csye-6225-final-project --tags mywebserver \
    --metadata startup-script="#! /bin/bash
      sudo apt-get update
      sudo apt-get install apache2 -y
      sudo service apache2 restart
      echo '<!doctype html><html><body><h1>csye-instance3</h1></body></html>' | tee /var/www/html/index.html
      EOF"

## Create firewall rules to allow external traffic to these virtual machine instances.
gcloud compute firewall-rules create csye6225-allow-ingress-tcp-port80 --target-tags mywebserver --allow tcp:80
gcloud compute firewall-rules create csye6225-allow-ingress-tcp-port22 --target-tags mywebserver --allow tcp:22
gcloud compute firewall-rules create csye6225-allow-ingress-tcp-port443 --target-tags mywebserver --allow tcp:443

## Get the external IP addresses of your instances.
gcloud compute instances list

## Verify that each instance running.
##curl http://[EXTERNAL_IP_ADDRESS]


## Configure the load balancing service
## 1. Create a static external IP address for your load balancer.
gcloud compute addresses create csye-network-lb-ip-1 --region us-east1
## 2. Add an HTTP health check object.
gcloud compute http-health-checks create basic-check
## 3. Add a target pool in the same region as your virtual machine instances.
gcloud compute target-pools create csye-pool --region us-east1 --http-health-check basic-check
## 4. Add your instances to the target pool.
gcloud compute target-pools add-instances csye-pool --instances csye-instance1,csye-instance2,csye-instance3 --instances-zone us-east1-d
## 5. Add a forwarding rule serving on behalf of an external IP and port range that points to your target pool. For the --address field, use either the numeric IP address or its fully qualified name.
gcloud compute forwarding-rules create csye-rule --region us-east1 --ports 80 --address csye-network-lb-ip-1 --target-pool csye-pool

## Send traffic to your instances
## 1. Look up the forwarding rule's external IP address:
gcloud compute forwarding-rules describe csye-rule --region us-east1 #35.196.18.8
## 2. Use the curl command to access the IP address. The response will alternate randomly among the three instances. If your response is initially unsuccessful, you might need to wait ~30 seconds for the configuration to be fully loaded and for your instances to be marked healthy before trying again:
while true; do curl -m1 35.196.18.8; done

## ************Cloud Pub/Sub**********Serverless (https://cloud.google.com/functions/docs/tutorials/pubsub) ******************************

gcloud components update && gcloud components install beta -Y

## Prepare environment for Node.js development.
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
cd ~/
git clone https://github.com/creationix/nvm.git .nvm
cd ~/.nvm
git checkout v0.33.7
. nvm.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install stable
nvm alias default stable
npm install --save @google-cloud/storage

## Preparing the application
## 1. Create a Cloud Storage bucket to stage your Cloud Functions files, where [YOUR_STAGING_BUCKET_NAME] is a globally unique bucket name
gsutil mb gs://csye6225-serverless-bucket
cd ~/gcf_pubsub

## create bigtable
gcloud beta bigtable instances create instance-bigtable --cluster=csye6225-final-cluster --cluster-zone=us-east1-b --description=test --cluster-num-nodes=3

## create rds instance
gcloud sql instances create sql-instance --tier=db-g1-small --region=us-east1
while true; do
InstanceStatus=`gcloud sql instances describe sql-instance | grep RUNNABLE`
echo $InstanceStatus
if [[ "$InstanceStatus" == "state: RUNNABLE" ]];
then
break
fi
done
gcloud sql databases create mySchema --instance=sql-instance
gcloud sql users set-password root % --instance sql-instance --password=root_access
gcloud sql users create user1 % --instance sql-instance --password=rootPassword

## Create a MANAGED ZONE
gcloud dns managed-zones create csye6225zone --dns-name csye6225-fall2017-sharmaj.me. --description zonedescription

## Starting Transaction
gcloud dns record-sets transaction start -z=csye6225zone

## Getting Static IP for Load Balancer
TempStaticIP=`gcloud compute forwarding-rules describe csye-rule --region us-east1 | grep IPAddress`
endIndex=`expr ${#TempStaticIP} - 1`
StaticIP=`echo $TempStaticIP | cut -c 12-$endIndex`

## Create Resource Record Set
gcloud dns record-sets transaction add --zone csye6225zone --name=csye6225-fall2017-sharmaj.me. --ttl=60 --type=A $StaticIP

## Executing a transaction
gcloud dns record-sets transaction execute -z=csye6225zone

## Create SNS Topic
gcloud beta pubsub topics create csye6225topic

## Create Google Cloud Function
#gcloud beta functions deploy helloWorld --stage-bucket csye6225-fall2017-gcp-final --trigger-http --trigger-topic=csye6225topic
gcloud beta functions deploy helloPubSub --stage-bucket csye6225-serverless-bucket --trigger-http

## Triggering the function
## 1. Publish a message to your Cloud Pub/Sub topic:
gcloud beta pubsub topics publish gcp-sns '{"name":"helloPubSub"}'




## *************************** Auto Scaling ******************************************************
gcloud compute instance-templates create csye6225-myinstance-template --machine-type f1-micro --project csye-6225-final-project

 gcloud compute instance-groups managed create csye6225-myinstance-group \
  --base-instance-name test \
  --size 3 \
  --template csye6225-myinstance-template \
  --zone us-east1-d

gcloud compute instance-groups managed set-autoscaling csye6225-myinstance-group \
    --max-num-replicas 20 \
    --target-cpu-utilization 0.75 \
    --cool-down-period 90

## to validate the auto scaling :
gcloud compute instance-groups managed describe csye6225-myinstance-group --zone us-east1-d
