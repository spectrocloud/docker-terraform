FROM zzxwill/docker-terraform-base:1.0.3-alpha-2

RUN

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["tail", "-f", "/dev/null"]

ENV TERRAFORM_VERSION=1.0.2
RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/broadinstitute/docker-terraform"
