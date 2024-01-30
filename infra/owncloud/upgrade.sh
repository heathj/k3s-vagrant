#!/bin/bash
set -euox pipefail

kubectx home-lab
kubectl create namespace owncloud --dry-run=client -o yaml | kubectl apply -f -
git clone https://github.com/owncloud/ocis-charts.git ./ocis-charts
cd ./ocis-charts
git checkout tags/v0.5.0
cd - 
helm upgrade --install ocis ./ocis-charts/charts/ocis -n owncloud --values values.yml
rm -rf ./ocis-charts
