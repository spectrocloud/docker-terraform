#!/bin/bash
set -x 
# tag=20230312
registry=spectro-dev-public
tag=$(date +%Y%m%d)
docker buildx build --platform linux/amd64 -t gcr.io/$registry/${USER}/terraform-executor:$tag . 
docker push gcr.io/$registry/${USER}/terraform-executor:$tag
