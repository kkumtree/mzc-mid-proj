#!/bin/bash

DEBIAN_FRONTEND=noninteractive

unset DEBIAN_FRONTEND

sudo apt-get update -yqq && sudo apt-get -yqq install -o Dpkg::Options::="--force-confnew" podman