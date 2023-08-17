#!/bin/bash

DEBIAN_FRONTEND=noninteractive

DOT_ENV="$HOME/variable/kubeadm/.env"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <type>"
  echo "type: [ctrl|lb|node]"
  exit 1
fi

TYPE=$1

# Check if the .env file exists
if [[ ! -f "$DOT_ENV" ]]; then
  echo "ERROR: $DOT_ENV not found."
  exit 1
fi

# Read the .env file and set the environment variables
source $DOT_ENV

API_SERVER_ADVERTISE_ADDRESS=$(echo $API_SERVER_ADVERTISE_ADDRESS | tr -d '\n\t\r')
POD_NETWORK_CIDR=$(echo $POD_NETWORK_CIDR | tr -d '\n\t\r')
CONTROL_PLANE_ENDPOINT=$(echo $CONTROL_PLANE_ENDPOINT | tr -d '\n\t\r')

# Check if variables are set
if [[ -z "$API_SERVER_ADVERTISE_ADDRESS" || -z "$POD_NETWORK_CIDR" || -z "$CONTROL_PLANE_ENDPOINT" ]]; then
  echo "ERROR: KUBEADM_{ API_SERVER_ADVERTISE_ADDRESS || POD_NETWORK_CIDR || CONTROL_PLANE_ENDPOINT } not set in the .env file."
  exit 1
fi

# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

sudo kubeadm init \
  --control-plane-endpoint=$CONTROL_PLANE_ENDPOINT \
  --apiserver-advertise-address=$API_SERVER_ADVERTISE_ADDRESS \
  --pod-network-cidr=$POD_NETWORK_CIDR \
  --cri-socket=unix://var/run/crio/crio.sock \
  --upload-certs | \
sudo tee /vagrant/log/$TYPE/.kubeadm-init_$(date '+%y%m%d_%H%M%S').log

# enable vagrant user use kubectl command
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sleep 5
