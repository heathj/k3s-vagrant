#!/bin/bash
set -euox pipefail

kubectx home-lab
helm repo add traefik https://traefik.github.io/charts
helm upgrade --install traefik traefik/traefik --version "26.0.0" --values values.yml -n kube-system