#!/bin/bash
set -euox pipefail

kubectx home-lab
kubectl create namespace metrics --dry-run=client -o yaml | kubectl apply -f -
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo update
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack -n metrics --version 56.2.0