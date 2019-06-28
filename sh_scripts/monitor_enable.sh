#!/bin/bash

docker exec `docker ps -q -l` /bin/bash -c \
"cd /;cd terraform; terraform apply -target=null_resource.monitor_enable --auto-approve"