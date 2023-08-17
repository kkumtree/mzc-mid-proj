#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# enable service
sudo systemctl restart crio
sudo systemctl enable crio
sudo systemctl restart kubelet
sudo systemctl enable kubelet