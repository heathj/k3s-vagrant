#!/bin/sh

set -euox pipefail

kubectl config use-context home-lab
kubectl create namespace argo --dry-run=client -o yaml | kubectl apply -f -

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argo argo/argo-cd -n argo --version "7.7.1" --values values.yml
