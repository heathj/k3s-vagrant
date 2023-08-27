# temporarily update resolv.conf in case that mirrors could not be resolved
cat <<EOF >> /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
systemctl restart systemd-networkd

apt -y update && apt -y upgrade && apt install -y net-tools resolvconf


# add nameserver so that external domains could be resolved inside pods
# https://rancher.com/docs/rancher/v2.5/en/troubleshooting/dns/

#cat <<EOF >> /etc/resolvconf/resolv.conf.d/head
#nameserver 8.8.8.8
#nameserver 8.8.4.4
#EOF

#sudo resolvconf -u