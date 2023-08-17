#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# chk param

if [ $# -ne 1 ]; then
  echo "Usage: $0 <type>"
  echo "type: [pipe|img|nfs|front]"
  exit 1
fi

####################

sudo apt-get update -yqq && sudo apt-get -yqq upgrade

####################

# env

TYPE="$1"

####################

# install apt-get

/bin/bash /vagrant/shell/common/essential-package.sh

####################

# install cri-o

/bin/bash /vagrant/shell/package/crio/install.sh

####################

# install podman

/bin/bash /vagrant/shell/package/podman/install.sh

# login dockerhub

/bin/bash /vagrant/shell/package/podman/login-docker.sh