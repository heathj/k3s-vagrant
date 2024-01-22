#!/bin/bash
set -euox pipefail

kubectl create namespace plex --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f ./ingress.yml
helm repo add plex https://raw.githubusercontent.com/plexinc/pms-docker/gh-pages  
helm upgrade --install plex plex/plex-media-server --version "0.1.8" --values values.yml -n plex