FROM alpine:3.18
RUN \
  apk update && \
  apk add bash libvirt-dev libvirt-client libxslt && \
  apk add --virtual=build libffi-dev make && \
  apk add curl jq unzip wget && \
  apk del --purge build
RUN apk add --no-cache cdrkit p7zip
RUN apk add --update --no-cache openssh sshpass
RUN apk upgrade curl

VOLUME ["/data"]

WORKDIR /data

COPY retrieve_tf_provider.sh /tmp
COPY retrieve_tf_provider_github.sh /tmp
COPY retrieve_tf_provider_http.sh /tmp
COPY bin/terraform /usr/bin
COPY bin/govc /usr/local/bin/govc
COPY bin/kubectl /usr/local/bin/kubectl

ENV RETRIEVE_TF_PROVIDER=/tmp/retrieve_tf_provider.sh
ENV RETRIEVE_TF_GITHUB_PROVIDER=/tmp/retrieve_tf_provider_github.sh
ENV RETRIEVE_TF_HTTP_PROVIDER=/tmp/retrieve_tf_provider_http.sh

RUN $RETRIEVE_TF_PROVIDER random 3.5.1
RUN $RETRIEVE_TF_PROVIDER kubernetes 2.23.0

RUN $RETRIEVE_TF_PROVIDER null 3.2.1
RUN $RETRIEVE_TF_PROVIDER vsphere 2.4.3

RUN cp -r .terraform.d /providers

RUN mkdir -p /providers/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.1/linux_amd64/
COPY terraform-providers/terraform-provider-libvirt_v0.7.1 /providers/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.1/linux_amd64/

COPY exec.sh /providers/exec.sh
RUN chmod +x /providers/exec.sh

ENTRYPOINT ["tail", "-f", "/dev/null"]