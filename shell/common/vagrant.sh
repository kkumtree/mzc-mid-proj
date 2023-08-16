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

if [ $TYPE = "pipe" ]; then
  /bin/bash $SHELL_FOR_VAGRANT $TYPE
  exit 0
fi

####################

if [ $TYPE = "img" ]; then
  /bin/bash $SHELL_FOR_VAGRANT $TYPE
  exit 0
fi

####################

if [ $TYPE = "nfs" ]; then
  /bin/bash $SHELL_FOR_VAGRANT $TYPE
  exit 0
fi

####################

if [ $TYPE = "front" ]; then
  /bin/bash $SHELL_FOR_VAGRANT $TYPE
  exit 0
fi

####################

exit 1