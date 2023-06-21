FROM alpine:3.17.3
RUN \
  apk update && \
  apk add bash py-pip pkgconfig libvirt-dev libvirt-client libxslt g++&& \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  apk add curl jq python3 ca-certificates git openssl unzip wget mysql-client && \
  pip --no-cache-dir install -U pip && \
  pip install azure-cli && \
  apk del --purge build

RUN wget https://github.com/vmware/govmomi/releases/download/v0.21.0/govc_linux_amd64.gz && \
gunzip govc_linux_amd64.gz && chmod +x govc_linux_amd64 && mv govc_linux_amd64 /usr/local/bin/govc

RUN apk add --update --no-cache openssh sshpass

RUN apk add --no-cache cdrkit p7zip

VOLUME ["/data"]

WORKDIR /data

ENV TERRAFORM_VERSION=1.4.6
COPY terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp
RUN cd /tmp && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
COPY retrieve_tf_provider.sh /tmp
COPY retrieve_tf_provider_github.sh /tmp
COPY retrieve_tf_provider_http.sh /tmp

# COPY ossutil /usr/bin
COPY oras/oras_1.0.0-rc.2_linux_amd64.tar.gz .
RUN mkdir -p oras-install/
RUN tar -zxf oras_1.0.0-rc.2_linux_amd64.tar.gz -C oras-install/
RUN mv oras-install/oras /usr/bin/oras
RUN chmod +x /usr/bin/oras
RUN rm -rf oras_1.0.0-rc.2_linux_amd64.tar.gz oras-install/

COPY kubectl/kubectl-1.27.1-linux-amd64 /usr/bin/kubectl

ENV RETRIEVE_TF_PROVIDER=/tmp/retrieve_tf_provider.sh
ENV RETRIEVE_TF_GITHUB_PROVIDER=/tmp/retrieve_tf_provider_github.sh
ENV RETRIEVE_TF_HTTP_PROVIDER=/tmp/retrieve_tf_provider_http.sh

RUN $RETRIEVE_TF_PROVIDER random 3.4.3
RUN $RETRIEVE_TF_PROVIDER kubernetes 2.18.1

RUN $RETRIEVE_TF_PROVIDER null 3.2.1
RUN $RETRIEVE_TF_PROVIDER vsphere 2.3.1

RUN cp -r .terraform.d /providers

RUN mkdir -p /providers/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.1/linux_amd64/
COPY terraform-providers/terraform-provider-libvirt_v0.7.1 /providers/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.1/linux_amd64/

COPY exec.sh /providers/exec.sh
RUN chmod +x /providers/exec.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]