#!/bin/bash
set -euox pipefail

kubectl create namespace plex --dry-run=client -o yaml | kubectl apply -f -
helm repo add plex https://raw.githubusercontent.com/plexinc/pms-docker/gh-pages  
helm upgrade --install plex plex/plex-media-server --values values.yml -n plex