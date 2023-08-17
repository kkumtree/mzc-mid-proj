#!/bin/bash

DEBIAN_FRONTEND=noninteractive

REGISTRY_FILE=$HOME/variable/calico/quay_registry.yaml

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml 
kubectl create -f $REGISTRY_FILE

# calicoctl
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calicoctl.yaml
# kubectl apply -f $HOME/shell/calico/calicoctl-tolerations.yaml
# kubectl exec -ti -n kube-system calicoctl -- /calicoctl get profiles -o wide
# echo "alias calicoctl='kubectl exec -i -n kube-system calicoctl -- /calicoctl'" >> ~/.bash_aliases
# kubectl wait --for=condition=Ready pods calicoctl -n kube-system

# calico BGP mode for metallb
# cat $HOME/shell/calico/calico-bgpconfiguration.yaml | calicoctl create -f -

# kubectl label node kube-controller node.kubernetes.io/exclude-from-external-load-balancers=true