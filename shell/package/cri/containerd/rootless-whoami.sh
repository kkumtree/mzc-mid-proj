#!/bin/bash

DEBIAN_FRONTEND=noninteractive

####################

# After changing the systemd config, re-login or reboot required.
# rebooting the host recommended.

####################
# login

# chk $XDG_RUNTIME_DIR

if [ -z "$XDG_RUNTIME_DIR" ]; then
  echo "XDG_RUNTIME_DIR is not set"
  exit 1
fi

# (optional) run containers automatically on system start-up
# $ sudo loginctl enable-linger $(whoami)

# (optional) enable dbus user session for systemd, cgroup v2
# $ systemctl --user is-active dbus
#
# if not automatically started, run:
# $ systemctl --user start dbus
# and you may
# $ systemctl --user enable --now dbus

####################
# /etc/subuid, /etc/subgid

# chk /etc/subuid, /etc/subgid

if [ ! -f /etc/subuid ]; then
  echo "subuid is not set"
  exit 1
fi

if [ ! -f /etc/subgid ]; then
  echo "subgid is not set"
  exit 1
fi

# if not set, run:
# $ sudo vi /etc/subuid
# OR, run:
# $ sudo usermod --add-subuids 100000-165536 --add-subgids 100000-165536 $(whoami)

####################
# (optional) cgroup v2 
# need kernel 4.15 or later (recommended 5.2+)

# chk cgroup v2

if [ ! -d /sys/fs/cgroup/cgroup.controllers ]; then
  echo "cgroup v2 is not set"
  # (Opt.1) Ubuntu on Azure
#   sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub.d/50-cloudimg-settings.cfg
  # (Opt.2) others
  sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub
  sudo update-grub
fi

# enable CPU/CPUSET, and I/O delegation
# Delegate `cpuset` requires `systemd 244+``

# if [ ! -f /etc/systemd/system/user.slice.d/50-cpu-cpuset-io-delegation.conf ]; then
#   sudo mkdir -p /etc/systemd/system/user.slice.d
#   sudo tee /etc/systemd/system/user.slice.d/50-cpu-cpuset-io-delegation.conf <<EOF

sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload

####################
# (optional) sysctl

# allow ping without root
# $ sudo sysctl -w net.ipv4.ping_group_range="0 65535"

cat <<EOF | sudo tee /etc/sysctl.d/99-rootless.conf
# net.ipv4.ping_group_range=0 65535
net.ipv4.ping_group_range=0 2147483647
EOF

