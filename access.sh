#!/bin/bash

# Run the existed container as provisioning environment
docker_env=`docker container ls`
if [ "$docker_env" == "CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES" ]; then 
	docker start  `docker ps -q -l`
fi
docker attach `docker ps -q -l`