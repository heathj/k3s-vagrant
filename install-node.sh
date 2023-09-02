K3S_TOKEN=$(cat /vagrant/node-token)

echo "token=${K3S_TOKEN}, masterIP=${MASTER_EXTERNAL_IP} nodeExternalIP=${NODE_EXTERNAL_IP} nodeInternalIP=${NODE_INTERNAL_IP}"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-external-ip ${NODE_EXTERNAL_IP} --node-ip ${NODE_INTERNAL_IP}--flannel-backend=wireguard-native --flannel-iface=wg0" \
    INSTALL_K3S_VERSION="${K3S_VERSION}" \
    K3S_URL="https://${MASTER_EXTERNAL_IP}:6443" \
    K3S_TOKEN="$K3S_TOKEN" \
    sh - 