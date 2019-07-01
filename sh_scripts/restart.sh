#!/bin/bash

docker exec `docker ps -q -l` /bin/bash -c \
"cd /;cd terraform;terraform apply -target=aws_s3_bucket.cluster_bucket -target=null_resource.cluster_apply -target=null_resource.cluster_destroy --auto-approve"
