K3S_VERSION ="v1.27.4+k3s1"

EXTERNAL_IP_BASE="192.168.56.10"
INTERNAL_IP_BASE="10.0.0.1"

MASTER_CPUS   = 1
MASTER_MEMORY = 2048

NUM_NODE=2
NODE_CPUS     = 2
NODE_MEMORY   = 2048

def generate_peer(peer)
    template = <<TEMPLATE
[Peer]
Endpoint: #{peer[:external_ip]}
PublicKey: #{peer[:public_key]}
AllowedIPs: #{peer[:internal_ip]}
TEMPLATE
end

def generate_interface(node)
    template = <<TEMPLATE
[Interface]
PrivateKey: #{node[:private_key]}
Address: #{node[:internal_ip]}
ListenPort: 51871
TEMPLATE
end

def generate_wg_conf(interface, peers)
    template = <<TEMPLATE
#{generate_interface(interface)}
#{peers.map{|peer| generate_peer(peer)}.join("\n")}
TEMPLATE
end

def generate_wg_peers(num_nodes, external_ip_base, internal_ip_base)
    peersList =[]
    for i in 0..num_nodes
        `wg genkey | tee privatekey | wg pubkey > publickey`
        public_key = File.read("publickey").strip
        private_key = File.read("privatekey").strip
        File.delete("publickey")
        File.delete("privatekey")
        peer_list.append({:public_key => public_key, :private_key => private_key, :external_ip => "#{external_ip_base}#{i}", :internal_ip => "#{internal_ip_base}#{i}"})
    end

    return peer_list
end

def peer_list_to_conf(peer_list)
    conf= {}
    peer_list.each do |peer|
        conf[peer[:internal_ip]] = {:peers => {}, :interface => {}}
    end
    peer_list.each do |peer|
        peer_list.each do |peer2|
            if peer[:public_key] == peer2[:public_key]
                conf[peer[:internal_ip]][:interface] = peer
                next
            end

            conf[peer[:internal_ip]][:peers][peer2[:internal_ip]] = peer2
        end
    end

    return conf
end

def write_wg_conf(num_nodes, external_ip_base, internal_ip_base)
    peer_list = generate_wg_peers(num_nodes, external_ip_base, internal_ip_base)
    conf = peer_list_to_conf(peer_list)
    conf.each do |node, config|
        File.write("#{node}.conf", generate_wg_conf(config[:interface], config[:peers].values))
    end

    return conf
end

Vagrant.configure("2") do |config|
    `rm *.confg`
    wg_conf = write_wg_conf(NUM_NODE, EXTERNAL_IP_BASE, INTERNAL_IP_BASE)
    config.vm.box = "ubuntu/kinetic64"
    config.vm.box_check_update = false
    config.vm.provider "virtualbox" do |vb|
        vb.memory = NODE_MEMORY
        vb.cpus = NODE_CPUS
    end
    config.vm.provision "shell", path: "common.sh",  
        env: {"WG_CONFIG_FILE" => "#{key}.conf"}

    wg_conf.each_with_index.map do |key, value, i|
        if i == 0 do
                master.vm.provider "virtualbox" do |vb|
                    vb.memory = MASTER_MEMORY
                    vb.cpus = MASTER_CPUS
                end
                master.vm.network "private_network", ip: value[:interface][:external_ip]
                master.vm.hostname = "master"
                master.vm.provision "shell", 
                    env: {"MASTER_EXTERNAL_IP" => value[:interface][:external_ip], "MASTER_INTERNAL_IP" => value[:interface][:internal_ip], "K3S_VERSION" => K3S_VERSION}, 
                    path: "install-master.sh"
            end
            next
        end

        config.vm.define "node0#{i}" do |node|        
            node.vm.network "private_network", ip: value[:interface][:external_ip]
            node.vm.hostname = "node0#{i}"
            node.vm.provision "shell", path: "install-node.sh", 
                env: {"MASTER_EXTERNAL_IP" => MASTER_EXTERNAL_IP, "K3S_VERSION" => K3S_VERSION, "NODE_EXTERNAL_IP" => value[:interface][:external_ip], "NODE_INTERNAL_IP" => value[:interface][:external_ip]}
        end
    end
end
