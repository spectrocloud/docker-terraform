#!/bin/bash
set -x 
# tag=20221209
tag=$(date +%Y%m%d)
docker buildx build --platform linux/amd64 -t gcr.io/spectro-bulwark/${USER}/terraform-executor:$tag . 
docker push gcr.io/spectro-bulwark/${USER}/terraform-executor:$tag