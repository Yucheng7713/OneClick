#!/bin/bash
echo -n "Enter a name > "
read NAME
echo -n "Enter a registered subdomain > "
read SUBDOMAIN

# Check if the subdomain has already been used
# If it has, stop building
# If it hasn't, initiate building

# Set environment variables if needed
# echo 'FELLOW_NAME=$NAME' >> ~/.bash_profile
# echo 'REGISTERED_SUBDOMAIN=$SUBDOMAIN' >> ~/.bash_profile

# Build the directory as docker image
docker build -t oneclick_env .

# Run the build image to initiate the provisioning environment
docker run -i -t -d \
-e AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) \
-e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
-e KOPS_STATE_STORE="s3://clusters.$SUBDOMAIN" \
-p 8080:8080 \
-p 9090:9090 \
-p 3000:3000 \
-p 9093:9093 \
oneclick_env

# Provision Kubernetes cluster via Terraform in the provisioning environment
docker exec `docker ps -q -l` /bin/bash -c \
"cd /;cd terraform;touch terraform.tfvars;echo 'cluster_domain_name=\"$SUBDOMAIN\"' > terraform.tfvars; echo 'fellow_name=\"$NAME\"' >> terraform.tfvars"
docker exec `docker ps -q -l` /bin/bash -c \
"cd /;cd terraform;terraform init;terraform apply -target=aws_s3_bucket.cluster_bucket -target=null_resource.cluster_apply -target=null_resource.cluster_destroy --auto-approve"
