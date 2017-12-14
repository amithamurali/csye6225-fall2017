Command to create an instance on Google Cloud Compute


gcloud compute instances create csye-6225-project --zone us-east1-d --machine-type f1-micro --project csye-6225-webapp



-----NEW-----


gcloud compute instance-templates create csye6225-myinstance-template --machine-type f1-micro --project upbeat-grammar-163601

 gcloud compute instance-groups managed create csye6225-myinstance-group \
  --base-instance-name test \
  --size 3 \
  --template csye6225-myinstance-template \
  --zone us-east1-d

gcloud compute instance-groups managed set-autoscaling csye6225-myinstance-group \
    --max-num-replicas 20 \
    --target-cpu-utilization 0.75 \
    --cool-down-period 90

gcloud compute instance-groups managed describe csye6225-myinstance-group --zone us-east1-d



---Create three new virtual machines in a given zone(us-east1-d) and give them all the same tag (mywebserver)
gcloud compute instances create csye-6225-project-instance1 --zone us-east1-d --machine-type f1-micro --project upbeat-grammar-163601 --tags mywebserver
gcloud compute instances create csye-6225-project-instance2 --zone us-east1-d --machine-type f1-micro --project upbeat-grammar-163601 --tags mywebserver
gcloud compute instances create csye-6225-project-instance3 --zone us-east1-d --machine-type f1-micro --project upbeat-grammar-163601 --tags mywebserver

--Create a firewall rule to allow external traffic to these virtual machine instances
gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags mywebserver --allow tcp:80

---Get the external IP addresses of your instances
gcloud compute instances list



---Configure the load balancing service
--step1 - Create a static external IP address for your load balancer.
gcloud compute addresses create network-lb-ip-1 \
     --region us-east1

--step2 - Add an HTTP health check object.
gcloud compute http-health-checks create basic-check

--step3 - Add a target pool in the same region as your virtual machine instances.
gcloud compute target-pools create www-pool \
     --region us-east1 --http-health-check basic-check

--step4 - Add your instances to the target pool
gcloud compute target-pools add-instances www-pool \
     --instances csye-6225-project-instance1,csye-6225-project-instance2,csye-6225-project-instance3 \
     --instances-zone us-east1-d

--step5 - Add a forwarding rule serving on behalf of an external IP and port range that points to your target pool.
gcloud compute forwarding-rules create www-rule \
    --region us-east1 \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool



--Send traffic to your instances
--Look up the forwarding rule's external IP address:
gcloud compute forwarding-rules describe www-rule --region us-east1

--curl command to access the IP address
while true; do curl -m1 35.196.136.135; done
