# temporarily update resolv.conf in case that mirrors could not be resolved
cat <<EOF >> /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
systemctl restart systemd-networkd

apt -y update && apt -y upgrade && apt install -y net-tools resolvconf wireguard
cp /vagrant/${WG_CONFIG_FILE} /etc/wireguard/wg0.conf
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0