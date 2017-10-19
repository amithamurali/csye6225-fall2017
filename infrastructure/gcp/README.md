Command to create an instance on Google Cloud Compute


gcloud compute instances create csye-6225-project --zone us-east1-d --machine-type f1-micro --project csye-6225-webapp

different version of the above command:
gcloud compute instances create "csye6225-instance1" --description="myinstance" --disk=auto-delete=yes,boot=yes,mode=rw,name="disk-1" --machine-type "n1-standard-1" --maintenance-policy "terminate" --preemptible --no-require-csek-key-create --no-restart-on-failure --zone "us-east1-d"
