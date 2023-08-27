# -*- mode: ruby -*-
# vi: set ft=ruby :

NETWORK_BASE="192.168.56.10"
K3S_VERSION ="v1.27.4+k3s1"

MASTER_CPUS   = 1
MASTER_MEMORY = 2048
NODE_COUNT    = 1
NODE_CPUS     = 2
NODE_MEMORY   = 2048

MASTER_IP = "#{NETWORK_BASE}0"

# by default, virtualbox creates multiple network cards, which causes network issue
# when accessing pods accross nodes
# see: 
#     https://www.jeffgeerling.com/blog/2019/debugging-networking-issues-multi-node-kubernetes-on-virtualbox
#     https://stackoverflow.com/questions/66449289/is-there-any-way-to-bind-k3s-flannel-to-another-interface
# solution: add `--flannel-iface=enp0s8`

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/kinetic64"
    config.vm.box_check_update = false

    config.vm.provision "shell", path: "common.sh",  
        env: {}

    config.vm.define "master", primary: true do |master|
        master.vm.provider "virtualbox" do |vb|
            vb.memory = MASTER_MEMORY
            vb.cpus = MASTER_CPUS
        end
        master.vm.network "private_network", ip: MASTER_IP
        master.vm.hostname = "master"
        master.vm.provision "shell", 
            env: {"MASTER_IP" => MASTER_IP, "K3S_VERSION" => K3S_VERSION}, 
            path: "install-master.sh"
    end

    config.vm.provider "virtualbox" do |vb|
        vb.memory = NODE_MEMORY
        vb.cpus = NODE_CPUS
    end

    (1..NODE_COUNT).each do |i|
        config.vm.define "node0#{i}" do |node|
            NODE_IP = "#{NETWORK_BASE}#{i}"
            node.vm.network "private_network", ip: NODE_IP
            node.vm.hostname = "node0#{i}"
            node.vm.provision "shell", path: "install-node.sh", 
                env: {"MASTER_IP" => MASTER_IP, "K3S_VERSION" => K3S_VERSION, "NODE_IP" => NODE_IP}
        end
    end
end
