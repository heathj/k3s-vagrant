echo "installing k3s on master: ${K3S_VERSION}/${MASTER_EXTERNAL_IP}"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" \
    INSTALL_K3S_EXEC="--node-external-ip ${MASTER_EXTERNAL_IP} --node-ip ${MASTER_INTERNAL_IP} --flannel-backend=wireguard-native --flannel-iface=wg0" \
    sh -
cp /var/lib/rancher/k3s/server/node-token /vagrant/