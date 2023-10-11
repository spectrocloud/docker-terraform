#!/bin/bash
set -x 
BUILDER_GOLANG_VERSION=1.21
BUILD_ARGS="--build-arg BUILDER_GOLANG_VERSION=${BUILDER_GOLANG_VERSION}"
registry=spectro-bulwark
tag=$(date +%Y%m%d)
docker buildx build --platform linux/amd64 ${BUILD_ARGS} -t gcr.io/$registry/${USER}/terraform-executor:$tag . 
docker push gcr.io/$registry/${USER}/terraform-executor:$tag
