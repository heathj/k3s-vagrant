#!/bin/bash

set -euox pipefail

export HOMELAB_KUBECONFIG="${HOME}/.kube/home-lab-config"
ssh jheath@node1.local "sudo cat /etc/rancher/k3s/k3s.yaml" > ${HOMELAB_KUBECONFIG}
sed -i '' 's/127\.0\.0\.1/10\.0\.4\.200/g' ${HOMELAB_KUBECONFIG}
sed -i '' 's/default/home-lab/g' ${HOMELAB_KUBECONFIG}

export KUBECONFIG="${HOMELAB_KUBECONFIG}:${HOME}/.kube/config"
