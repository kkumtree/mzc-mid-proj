#!/bin/bash

DEBIAN_FRONTEND=noninteractive

####################

# After changing the systemd config, re-login or reboot required.
# rebooting the host recommended.

####################
# login

# chk $XDG_RUNTIME_DIR

if [ -z "$XDG_RUNTIME_DIR" ]; then
  echo "^*^XDG_RUNTIME_DIR is set MANUALLY and EXPORTED^*^"
  XDG_RUNTIME_DIR=/run/user/$(id -u)
  export XDG_RUNTIME_DIR
fi

if [ -z "$_CRIO_ROOTLESS" ]; then
  echo "^*^_CRIO_ROOTLESS is set MANUALLY and EXPORTED^*^"
  _CRIO_ROOTLESS=1
  export _CRIO_ROOTLESS
fi

echo "============================================="
echo "whoami: $(whoami)"
echo "XDG_RUNTIME_DIR is SET: $XDG_RUNTIME_DIR"
echo "_CRIO_ROOTLESS is SET: $_CRIO_ROOTLESS"
echo "============================================="

####################
# /etc/subuid, /etc/subgid

# chk /etc/subuid, /etc/subgid

if [ ! -f /etc/subuid ]; then
  echo "subuid is not set"
fi

if [ ! -f /etc/subgid ]; then
  echo "subgid is not set"
fi

# if not set, run:
# $ sudo vi /etc/subuid
# OR, run:
# $ sudo usermod --add-subuids 100000-165536 --add-subgids 100000-165536 $(whoami)

if [ ! -f /etc/subuid -o ! -f /etc/subgid ]; then
  sudo usermod --add-subuids 100000-165536 --add-subgids 100000-165536 $(whoami)
fi

####################
# add env to .bashrc

echo "*^*CHECK CRI-O ENVIRONMENT^*^"
echo "_CRIO_ROOTLESS=$_CRIO_ROOTLESS"
echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
echo "*^*IS IT RIGHT?^*^"

####################
# install cri-o

# following will be needed
# sudo loginctl enable-linger $(whoami) 
# OR bash --cgroup-manager=cgroupfs

# sudo loginctl enable-linger $(whoami)
# sudo chown -R $(whoami):$(whoami) /var/lib/containers/

# curl https://raw.githubusercontent.com/cri-o/cri-o/main/scripts/get | bash
curl https://raw.githubusercontent.com/cri-o/cri-o/main/scripts/get | sudo bash

####################
# disable crun

if [ -f "/etc/crio/crio.conf.d/runc.conf" ]; then
  if [ -f "/etc/crio/crio.conf.d/10-crun.conf" ]; then
    sudo rm /etc/crio/crio.conf.d/10-crun.conf
  fi
fi

####################
# enable and start cri-o

sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio