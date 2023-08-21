#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# argocd(non HA)
kubectl create namespace argocd
kubectl apply -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl rollout status deployment -n argocd

# # argo rollout-extension
# kubectl apply -n argocd \
#     -f https://raw.githubusercontent.com/argoproj-labs/rollout-extension/v0.2.1/manifests/install.yaml

# cat <<EOF | kubectl apply -f -
# apiVersion: argoproj.io/v1alpha1
# kind: ArgoCDExtension
# metadata:
#   name: argo-rollouts
# spec:
#   repository: https://github.com/argoproj-labs/rollout-extension
#   revision: HEAD
# EOF

# argocd cli
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# argo rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts \
    -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# argo workflow
kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.4.10/install.yaml
kubectl rollout status deployment -n argo
kubectl patch deployment \
  argo-server \
  --namespace argo \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
  "--auth-mode=server"
]}]'

# argo events
kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml
kubectl rollout status deployment -n argo-events