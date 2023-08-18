#!/bin/bash

DEBIAN_FRONTEND=noninteractive

####################
# After changing the systemd config, re-login or reboot required.
# rebooting the host recommended.
####################

echo "============================================="
echo "SYSTEM SETUP FOR ROOTLESS CONTAINER"
echo "whoami: $(whoami)"
echo "============================================="

####################
# (optional) run containers automatically on system start-up
# sudo loginctl enable-linger $(whoami)
sudo loginctl enable-linger $(whoami)

# (optional) enable dbus user session for systemd, cgroup v2
# systemctl --user is-active dbus

# if not automatically started, run:
# $ systemctl --user start dbus
# and you may
# $ systemctl --user enable --now dbus

####################
# (optional) cgroup v2 
# need kernel 4.15 or later (recommended 5.2+)

# chk cgroup v2

if [ ! -d /sys/fs/cgroup/cgroup.controllers ]; then
  echo "cgroup v2 is not set"
  # (Opt.1) Ubuntu on Azure
#   sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub.d/50-cloudimg-settings.cfg
  # (Opt.2) others
  sudo sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub
  sudo update-grub
fi

####################
# enable CPU/CPUSET, and I/O delegation
# Delegate `cpuset` requires `systemd 244+`

sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload

####################
# (optional) sysctl
# allow ping without root

cat <<EOF | sudo tee /etc/sysctl.d/99-rootless.conf
net.ipv4.ping_group_range = 0 21474836476
net.ipv4.ip_unprivileged_port_start=0
EOF

####################
# Apply sysctl params without reboot
sudo sysctl --system

####################
# USE the distribution's runc

sudo loginctl enable-linger $(whoami)

## Create the directory if it doesn't exist
sudo mkdir -p /etc/crio/crio.conf.d/

## Create the runc.conf file
sudo tee /etc/crio/crio.conf.d/runc.conf <<EOF
[crio.runtime.runtimes.runc]
runtime_path = ""
runtime_type = "oci"
runtime_root = "/run/runc"
EOF

####################
# enable overlay, cgroup

if [ -d "$HOME/conf" ]; then
  echo "SET overlay, cgroup"
  sudo cp --no-preserve=all "$(find $HOME/conf/crio/custom -name *custom.conf)" /etc/crio/crio.conf
fi

####################
# enable and start cri-o

sudo systemctl daemon-reload