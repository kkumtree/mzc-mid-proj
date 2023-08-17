#!/bin/bash

DEBIAN_FRONTEND=noninteractive

echo "=== Install: APT packages ==="
sudo apt-get -yq install curl gnupg2 software-properties-common apt-transport-https ca-certificates > /dev/null 2>&1
echo "=== Set: K8S(kubectl) repo ==="

# K8S repository

sudo mkdir -p /etc/apt/keyrings
# curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo apt-key add -
# echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "=== Set: Docker repo ==="

# Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# repo update
sudo apt-get update -yqq

sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a
sudo mount -a

echo "=== Install: containerd ==="


# install container runtime
# use systemdCgroup
# disable swap
sudo apt-get install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd.service

echo "=== Install: K8S ==="


# install K8S
sudo apt-get -y install kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# enable service
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl restart kubelet
sudo systemctl enable kubelet

sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# add hosts
sudo tee -a /etc/hosts <<EOF
# Vagrant setting
192.168.10.11 kube-controller
192.168.10.12 kube-worker-node1
192.168.10.13 kube-worker-node2
EOF

sudo -u root /bin/bash -c "crontab -l | sed -e 's/\(.*setup-package.sh\)/#\1/' | crontab -"



