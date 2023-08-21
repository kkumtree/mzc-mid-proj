#!/bin/bash

DEBIAN_FRONTEND=noninteractive

DOT_ENV="$HOME/variable/tailscale/.env"

# Check if the .env file exists
if [[ ! -f "$DOT_ENV" ]]; then
  echo "ERROR: $DOT_ENV not found."
  exit 1
fi

# Read the .env file and set the environment variables
source $DOT_ENV

# Check if variables are set
if [[ -z "$SERVICE_CIDR" || -z "$POD_CIDR" ]]; then
  echo "ERROR: SERVIC_CIDR or POD_CIDR not set in the .env file."
  exit 1
fi

SERVICE_CIDR=$(echo $SERVICE_CIDR | tr -d '\n\t\r')
POD_CIDR=$(echo $POD_CIDR | tr -d '\n\t\r')

# tailscale namespace, RBAC(Role, RB, SA)

export SA_NAME=tailscale
export TS_KUBE_SECRET=tailscale-auth
export TS_ROUTES=$SERVICE_CIDR,$POD_CIDR

kubectl apply -f ~/variable/tailscale/yml/rbac.yml

kubectl apply -f ~/variable/tailscale/yml/subnet-router.yml

# git clone https://github.com/tailscale/tailscale
# cd tailscale/docs/k8s

# make rbac | kubectl apply -f -
# make subnet-router | kubectl apply -f -

# # reset directory
# cd -

# https://github.com/gravitational/teleport/discussions/22747#discussioncomment-5269008

kubectl -n kube-system rollout restart deployment coredns