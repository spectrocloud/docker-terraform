FROM alpine:3.13

RUN \
  apk update && \
  apk add bash py-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  apk add curl jq python3 ca-certificates git openssl unzip wget && \
  pip --no-cache-dir install -U pip && \
  pip install azure-cli && \
  apk del --purge build

ENV TERRAFORM_VERSION=0.14.10

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["tail", "-f", "/dev/null"]

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

COPY terraform.d /root/terraform.d

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/broadinstitute/docker-terraform"
