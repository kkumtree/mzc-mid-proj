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
if [[ -z "$TS_AUTHKEY" ]]; then
  echo "ERROR: TS_AUTHKEY not set in the .env file."
  exit 1
fi

TS_AUTHKEY=$(echo $TS_AUTHKEY | tr -d '\n\t\r')

# tailscale auth-key

cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Secret
metadata:
  name: tailscale-auth
stringData:
  TS_AUTHKEY: $TS_AUTHKEY
EOF
