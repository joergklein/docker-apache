FROM centos:8

LABEL maintainer="Joerg Klein <kwp.klein@gmail.com>" \
      description="Docker base image for the Apache webserver"

RUN dnf update -y  \
    && dnf install -y httpd \
    && dnf clean all; systemctl enable httpd.service

EXPOSE 80
