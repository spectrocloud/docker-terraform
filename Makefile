# Image URL to use all building/pushing image targets
IMG ?= gcr.io/spectro-dev-public/${USER}/terraform-executor:$(shell date +%Y%m%d)
BULWARK_IMG ?= gcr.io/spectro-bulwark/${USER}/terraform-executor:$(shell date +%Y%m%d)
BUILDER_GOLANG_VERSION ?= 1.21
BUILD_ARGS = --build-arg BUILDER_GOLANG_VERSION=${BUILDER_GOLANG_VERSION}

.PHONY: docker-build
docker-build: ## Build docker image with the manager.
	docker buildx build --platform linux/amd64 ${BUILD_ARGS} -t ${IMG} .

.PHONY: docker-push
docker-push: ## Push docker image with the manager.
	docker push ${IMG}

.PHONY: docker-bulwark
docker-bulwark: 
	docker buildx build --platform linux/amd64 ${BUILD_ARGS} -t ${BULWARK_IMG} .
	docker push ${BULWARK_IMG}

.PHONY: upgrade-terraform-bin
upgrade-terraform-bin:
	bash hack/upgrade-terraform-bin.sh 

.PHONY: upgrade-kubectl-bin
upgrade-kubectl-bin:
	bash hack/upgrade-kubectl-bin.sh 

.PHONY: upgrade-govc-bin
upgrade-govc-bin:
	bash hack/upgrade-govc-bin.sh 