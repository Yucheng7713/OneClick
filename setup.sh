#!/bin/bash
echo "Enter your name > "
read NAME
echo "Enter your registered subdomain > "
read SUBDOMAIN

export FELLOW_NAME=$NAME
export REGISTERED_SUBDOMAIN=$SUBDOMAIN
# Build the directory as docker image
docker build -t oneclick_env .

# Run the build image to initiate the provisioning environment
docker run -i -t -d \
-e AWS_ACCESS_KEY_ID=$(aws confgure get aws_access_key_id) \
-e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
-e KOPS_STATE_STORE="s3://clusters.$SUBDOMAIN" \
--net=host \
-p 8080:8080 \
-p 9090:9090 \
-p 3000:3000 \
-p 9093:9093 \
oneclick_env
