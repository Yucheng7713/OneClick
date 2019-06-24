#!/bin/bash

# Set build image name/tag
# FLASK_IMAGE_TAG="$DOCKER_USER_NAME/oneclick-flaskapp"

# Clone the deploying project to app then build and push image to Docker Hub
# git clone $REMOTE_PATH app
# cp ./docker_build_template/Dockerfile ./app/Dockerfile \
# && docker build -t $FLASK_IMAGE_TAG ./app/. \
# && docker push $FLASK_IMAGE_TAG

# Run the existed container as provisioning environment
docker start  `docker ps -q -l` \
&& docker attach `docker ps -q -l`

docker exec `docker ps -q -l` /bin/bash -c "cd terraform;terraform init;terraform apply -var 'fellow_name=$FELLOW_NAME' -var 'cluster_domain_name=$REGISTERED_SUBDOMAIN' -auto-approve"

