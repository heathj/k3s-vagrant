systemctl restart systemd-networkd

apt -y update && apt -y upgrade && apt install -y net-tools resolvconf wireguard

cp /vagrant/${WG_CONFIG_FILE} /etc/wireguard/wg0.conf
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

ufw allow 51871/udp
ufw allow in from ${INTERNAL_IP_BASE}/16
