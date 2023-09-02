# -*- mode: ruby -*-
# vi: set ft=ruby :

NETWORK_BASE="192.168.56.10"
WIREGUARD_BASE="10.0.0.1"
K3S_VERSION ="v1.27.4+k3s1"

MASTER_CPUS   = 1
MASTER_MEMORY = 2048
NODE_COUNT    = 1
NODE_CPUS     = 2
NODE_MEMORY   = 2048

MASTER_IP = "#{NETWORK_BASE}0"
MASTER_WIREGUARD_IP = "#{WIREGUARD_BASE}0"


def generate_networks (i = 0, file = "peers.txt")
    `wg genkey | tee privatekey#{i} | wg pubkey > ./publickey#{i}`
    `echo "$(cat ./privatekey#{i}) $(cat ./publickey#{i}) #{NETWORK_BASE}#{i} #{WIREGUARD_BASE}#{i}" >> #{file}`
    `rm ./publickey#{i}`
    `rm ./privatekey#{i}`
end

`rm peers.txt && rm master.txt`
generate_networks(0, "master.txt")
(1..NODE_COUNT).each do |i|
    generate_networks i
end


Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/kinetic64"
    config.vm.box_check_update = false

    config.vm.define "master", primary: true do |master|

        master.vm.provision "shell", path: "common.sh",  
            env: {"WIREGUARD_IP" => MASTER_WIREGUARD_IP, "NODE_IP" => MASTER_IP}

        master.vm.provider "virtualbox" do |vb|
            vb.memory = MASTER_MEMORY
            vb.cpus = MASTER_CPUS
        end
        master.vm.network "private_network", ip: MASTER_IP
        master.vm.hostname = "master"
        master.vm.provision "shell", 
            env: {"WIREGUARD_IP" => MASTER_WIREGUARD_IP, "NODE_IP" => MASTER_IP, "K3S_VERSION" => K3S_VERSION}, 
            path: "install-master.sh"
    end

    config.vm.provider "virtualbox" do |vb|
        vb.memory = NODE_MEMORY
        vb.cpus = NODE_CPUS
    end

    (1..NODE_COUNT).each do |i|
        config.vm.define "node0#{i}" do |node|
            NODE_IP = "#{NETWORK_BASE}#{i}"
            WIREGUARD_IP_NODE = "#{WIREGUARD_BASE}#{i}"
            node.vm.provision "shell", path: "common.sh",  
                env: {"WIREGUARD_IP" => WIREGUARD_IP_NODE, "NODE_IP" => NODE_IP}
            
            node.vm.network "private_network", ip: NODE_IP
            node.vm.hostname = "node0#{i}"
            node.vm.provision "shell", path: "install-node.sh", 
                env: {"MASTER_IP" => MASTER_IP, "K3S_VERSION" => K3S_VERSION, "NODE_IP" => NODE_IP, "WIREGUARD_IP" => WIREGUARD_IP_NODE}
        end
    end
end
