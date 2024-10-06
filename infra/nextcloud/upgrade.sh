#!/bin/sh

set -euox pipefail

kubectl config use-context home-lab
kubectl create namespace nextcloud --dry-run=client -o yaml | kubectl apply -f -

helm repo add nextcloud https://nextcloud.github.io/helm/
helm repo update
helm upgrade --install nextcloud nextcloud/nextcloud -n nextcloud --version "4.6.4" --values values.yml
