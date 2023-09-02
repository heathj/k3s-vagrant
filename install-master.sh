echo "installing k3s on master: ${K3S_VERSION}/${NODE_IP}"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" \
    INSTALL_K3S_EXEC="--node-external-ip ${NODE_IP} --node-ip ${WIREGUARD_IP} --flannel-backend=wireguard-native --flannel-iface=wg0" \
    sh -
cp /var/lib/rancher/k3s/server/node-token /vagrant/