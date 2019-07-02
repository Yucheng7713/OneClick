#!/bin/bash

# Set build image name/tag
FLASK_IMAGE_TAG="$DOCKER_USER_NAME/oneclick-flaskapp"

# Clone the deploying project to app then build and push image to Docker Hub
rm -rf app
git clone $1 app
cp ./app_build_template/Dockerfile ./app/Dockerfile \
&& docker build -t $FLASK_IMAGE_TAG ./app/. \
&& docker push $FLASK_IMAGE_TAG

# Deploy Flask app image upon the Kubernetes cluster
# Use template to generate deployment yaml file
docker exec `docker ps -q -l` /bin/bash -c \
"rm ./k8s/flask-app-deployment.yaml;cat \"./k8s/flask-deploy-template.yaml\" | sed \"s/{{NAME_OF_IMAGE}}/$(echo $FLASK_IMAGE_TAG | perl -pe 's/\//\\\//g')/g\" > ./k8s/flask-app-deployment.yaml"

docker exec `docker ps -q -l` /bin/bash -c \
"cd /;cd terraform; terraform destroy -target=null_resource.app_deploy --auto-approve; terraform apply -target=null_resource.app_deploy --auto-approve"

docker exec `docker ps -q -l` /bin/bash -c \
"kubectl get service/flask-app" 

