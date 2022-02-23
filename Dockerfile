FROM alpine:3.13
RUN \
  apk update && \
  apk add bash py-pip pkgconfig libvirt-dev libvirt-client g++&& \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  apk add curl jq python3 ca-certificates git openssl unzip wget mysql-client && \
  pip --no-cache-dir install -U pip && \
  pip install azure-cli && \
  apk del --purge build

RUN apk add --no-cache cdrkit p7zip

VOLUME ["/data"]

WORKDIR /data

ENV TERRAFORM_VERSION=1.0.2
COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp
RUN cd /tmp && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
COPY retrieve_tf_provider.sh /tmp
COPY retrieve_tf_provider_github.sh /tmp
COPY retrieve_tf_provider_http.sh /tmp

COPY ossutil /usr/bin
RUN mkdir -p /rishi
COPY oras/terraform-provider-libvirt_v0.6.14 /rishi

ENV RETRIEVE_TF_PROVIDER=/tmp/retrieve_tf_provider.sh
ENV RETRIEVE_TF_GITHUB_PROVIDER=/tmp/retrieve_tf_provider_github.sh
ENV RETRIEVE_TF_HTTP_PROVIDER=/tmp/retrieve_tf_provider_http.sh

RUN $RETRIEVE_TF_HTTP_PROVIDER libvirt 0.6.14 dmacvicar
RUN $RETRIEVE_TF_PROVIDER random 3.1.0
RUN $RETRIEVE_TF_PROVIDER template 2.2.0
RUN $RETRIEVE_TF_PROVIDER kubernetes 2.7.1

RUN $RETRIEVE_TF_PROVIDER null 3.1.0
RUN $RETRIEVE_TF_PROVIDER vsphere 2.0.2
RUN $RETRIEVE_TF_PROVIDER local 2.1.0
#
#COPY providers.tf .
#RUN mkdir /providers && mv providers.tf /providers && cd /providers && terraform init && rm providers.tf

RUN cp -r .terraform.d /root/.terraform.d
RUN cp -r .terraform.d /providers

#COPY oras/oras_0.12.0_linux_amd64.tar.gz .
#RUN mkdir -p oras-install/
#RUN tar -zxf oras_0.12.0_*.tar.gz -C oras-install/
#RUN mv oras-install/oras ./oras
#RUN chmod +x ./oras
#RUN rm -rf oras_0.12.0_*.tar.gz oras-install/
#
COPY exec.sh /providers/exec.sh
RUN chmod +x /providers/exec.sh

#RUN mkdir debug
#COPY resource.tf debug/resource.tf

ENTRYPOINT ["tail", "-f", "/dev/null"]