#!/bin/bash

DEBIAN_FRONTEND=noninteractive

sudo apt-get install -yqq \
  curl gnupg2 software-properties-common apt-transport-https ca-certificates \
  nfs-common \
  jq \
  dbus-user-session uidmap \
  libseccomp2 \
  make