#!/bin/bash

DEBIAN_FRONTEND=noninteractive


DOT_ENV="$HOME/variable/dockerhub/.env"

# Check if the .env file exists
if [[ ! -f "$DOT_ENV" ]]; then
  echo "ERROR: $DOT_ENV not found."
  exit 1
fi

# Read the .env file and set the environment variables
source $DOT_ENV

# Check if variables are set
if [[ -z "$DOCKER_SERVER" || -z "$DOCKER_USERNAME" || -z "$DOCKER_PASSWORD" ]]; then
  echo "ERROR: DOCKER_{ SERVER_PODMAN || USERNAME || PASSWORD } not set in the .env file."
  exit 1
fi

kubectl create namespace kube-cred

kubectl create secret docker-registry regcred \
  --namespace=kube-cred \
  --docker-server=$DOCKER_SERVER \
  --docker-username=$DOCKER_USERNAME \
  --docker-password=$DOCKER_PASSWORD