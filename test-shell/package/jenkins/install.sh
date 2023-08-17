#!/bin/bash

DEBIAN_FRONTEND=noninteractive

podman run -it -d -p 8080:8080 --name jenkins \
    -v jenkins-volume:/var/jenkins_home/ \
    -v /var/run/crio/crio.sock:/var/run/crio/crio.sock \
    -v $(which crio):/usr/bin/crio \
    jenkins/jenkins:latest

podman exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword