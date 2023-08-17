#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin

sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a
sudo mount -a