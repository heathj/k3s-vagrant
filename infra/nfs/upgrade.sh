#!/bin/bash
set -euox pipefail

kubectx home-lab
kubectl create namespace storage --dry-run=client -o yaml | kubectl apply -f -
kubectl create configmap exports -n storage --from-file=./exports --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f ./deployment.yml
kubectl apply -f ./service.yml