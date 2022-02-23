FROM golang:alpine AS terraform-bundler-build

RUN apk --no-cache add git unzip && \
    git clone --single-branch --branch=v0.15 --depth=1 https://github.com/hashicorp/terraform.git

RUN cd terraform && go install ./tools/terraform-bundle

COPY terraform-bundle.hcl .

RUN terraform-bundle package terraform-bundle.hcl && \
    mkdir -p terraform-bundle && \
    unzip -d terraform-bundle terraform_*.zip

####################

FROM python:alpine

RUN apk add --no-cache git make && \
    pip install awscli
#
#COPY --from=terraform-bundler-build /go/terraform/tools/terraform-bundle/* /usr/local/bin/

COPY --from=terraform-bundler-build /go/terraform-bundle/* /usr/local/bin/