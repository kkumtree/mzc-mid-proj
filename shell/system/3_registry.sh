#!/bin/bash

DEBIAN_FRONTEND=noninteractive

DOT_ENV="/vagrant/variable/dockerhub/.env"

# Check if the .env file exists
if [[ ! -f "$DOT_ENV" ]]; then
  echo "ERROR: $DOT_ENV not found."
  exit 1
fi

# Read the .env file and set the environment variables
source $DOT_ENV

# Check if variables are set
if [[ -z "$DOCKER_SERVER" || -z "$DOCKER_USERNAME" || -z "$DOCKER_PASSWORD" ]]; then
  echo "ERROR: DOCKER_{ SERVER || USERNAME || PASSWORD } not set in the .env file."
  exit 1
fi

DOCKER_SERVER=$(echo $DOCKER_SERVER | tr -d '\n\t\r')
DOCKER_USERNAME=$(echo $DOCKER_USERNAME | tr -d '\n\t\r')
DOCKER_PASSWORD=$(echo $DOCKER_PASSWORD | tr -d '\n\t\r')

####################
# add registry to conf

sudo mkdir -p /etc/containers

cat <<EOF | sudo tee /etc/containers/registries.conf
[registries.search]
registries = ['docker.io', 'quay.io', 'registry.fedoraproject.org', 'registry.access.redhat.com', 'registry.centos.org']
EOF

cat <<EOF | sudo tee /etc/containers/auth-custom.json
{
  "auths": {
    "$DOCKER_SERVER": {
      "auth": "$(echo -n "$DOCKER_USERNAME:$DOCKER_PASSWORD" | base64)"
    }
  }
}
EOF
