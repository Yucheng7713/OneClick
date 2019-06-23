#!/bin/bash

# Clone the deploying project to app then build and push image to Docker Hub
export export FLASK_IMAGE_TAG={$DOCKER_REGISTRY_NAME}/oneclick-flaskapp
cp ./docker_build_template/Dockerfile ./app/Dockerfile \
&& docker login -u=$DOCKER_REGISTRY_NAME -p=$DOCKER_PASSWORD \
&& docker build -t $FLASK_IMAGE_TAG ./app/. \
&& docker push $FLASK_IMAGE_TAG

# Run the docker image to initiate the provisioning environment

docker run -it $ONECLICK_IMAGE 
docker exec $ONECLICK_IMAGE /bin/sh -c "export "