#!/usr/bin/env bash

DIRNAME=$(dirname "$0")
INSTALL_GLUSTERFS=${INSTALL_GLUSTERFS:-false}
INSTALL_DOCKER=${INSTALL_DOCKER:-false}

packer build \
  -var-file "${DIRNAME}/credentials.pkrvars.hcl" \
  -var "install_glusterfs=$INSTALL_GLUSTERFS" \
  -var "install_docker=$INSTALL_DOCKER" \
  debian.pkr.hcl
