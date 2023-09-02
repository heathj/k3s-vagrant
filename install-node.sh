TOKEN=$(cat /vagrant/node-token)

MASTER_IP=$MASTER_IP
NODE_IP=$NODE_IP
K3S_VERSION=$K3S_VERSION

echo "token=${TOKEN}, masterIP=${MASTER_IP} nodeIP=${NODE_IP} wireguardIP=${WIREGUARD_IP}"

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-external-ip ${NODE_IP} --node-ip ${WIREGUARD_IP}--flannel-backend=wireguard-native --flannel-iface=wg0" \
    INSTALL_K3S_VERSION="${K3S_VERSION}" \
    K3S_URL="https://${MASTER_IP}:6443" \
    K3S_TOKEN="$TOKEN" \
    sh - 