#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# chk param

if [ $# -ne 1 ]; then
  echo "Usage: $0 <type>"
  echo "type: [pipe|img|nfs|front]"
  exit 1
fi

####################

# env

TYPE="$1"
SHELL_FOR_VAGRANT="/vagrant/shell/ubuntu/${TYPE}/init.sh"

####################

exit 1