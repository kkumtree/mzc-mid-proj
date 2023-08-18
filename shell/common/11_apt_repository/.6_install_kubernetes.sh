#!/bin/bash

DEBIAN_FRONTEND=noninteractive

sudo apt-get -yqq install kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl