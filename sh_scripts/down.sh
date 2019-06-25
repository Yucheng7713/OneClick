#!/bin/bash

docker exec `docker ps -q -l` /bin/bash -c \
"cd terraform; terraform destroy --auto-approve"