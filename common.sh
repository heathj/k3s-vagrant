# temporarily update resolv.conf in case that mirrors could not be resolved
cat <<EOF >> /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
systemctl restart systemd-networkd

apt -y update && apt -y upgrade && apt install -y net-tools resolvconf wireguard

# setup wireguard
wg genkey > private
PUBLIC_KEY=$(wg pubkey < private)
PEERS_FILE=/vagrant/peers.txt
echo "${PUBLIC_KEY} ${WIREGUARD_IP} ${NODE_IP}" >> ${PEERS_FILE}

# IFACE_WG=wg0
# ip link add ${IFACE_WG} type wireguard
# ip addr add ${WIREGUARD_IP}/16 dev ${IFACE_WG}
# wg set ${IFACE_WG} private-key ./private
# ip link set ${IFACE_WG} up


# for peer in $(cat ${PEERS_FILE}); do
#     P=$(echo ${peer} | cut -d " " -f 1)
#     I=$(echo ${peer} | cut -d " " -f 2)
#     E=$(echo ${peer} | cut -d " " -f 3)
#     wg set ${IFACE_WG} peer ${P} allowed-ips "${I}/32" endpoint ${E}:
    
# done