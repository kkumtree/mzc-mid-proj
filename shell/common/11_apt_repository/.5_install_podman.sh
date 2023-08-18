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

####################
# install podman

unset DEBIAN_FRONTEND

sudo apt-get update -yqq && sudo apt-get -yqq install -o Dpkg::Options::="--force-confnew" podman

####################
# login dockerhub

# Check if variables are set
if [[ -z "$DOCKER_SERVER_PODMAN" || -z "$DOCKER_USERNAME" || -z "$DOCKER_PASSWORD" ]]; then
  echo "ERROR: DOCKER_{ SERVER_PODMAN || USERNAME || PASSWORD } not set in the .env file."
  exit 1
fi

DOCKER_SERVER_PODMAN=$(echo $DOCKER_SERVER_PODMAN | tr -d '\n\t\r')
DOCKER_USERNAME=$(echo $DOCKER_USERNAME | tr -d '\n\t\r')
DOCKER_PASSWORD=$(echo $DOCKER_PASSWORD | tr -d '\n\t\r')

podman login $DOCKER_SERVER_PODMAN \
  -u $DOCKER_USERNAME \
  -p $DOCKER_PASSWORD