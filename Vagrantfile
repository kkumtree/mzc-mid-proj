# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"

    config.vm.define "pipeline" do |pipeline|
        pipeline.vm.hostname = "jenkins"
        pipeline.vm.provider "virtuaimageox" do |vb|
            vb.name = "jenkins"
            vb.cpus = 4
            vb.memory = 8192
        end
        pipeline.vm.network "private_network", ip: "192.168.77.11"
        pipeline.vm.provision "shell", 
        inline: "/bin/bash /vagrant/shell/common/vagrant.sh pipeline"
    end

    config.vm.define "store-img" do |img|
        img.vm.hostname = "registry"
        img.vm.provider "virtualbox" do |vb|
            vb.name = "registry"
            vb.cpus = 2
            vb.memory = 4096
        end
        img.vm.network "private_network", ip: "192.168.77.12"
        img.vm.network "public_network"
        img.vm.provision "shell", inline: <<-SCRIPT
            sudo apt-get -yqq update && sudo apt-get -yqq install nginx
        SCRIPT
    end

    config.vm.define "img" do |img|
        img.vm.hostname = "registry"
        img.vm.provider "virtualbox" do |vb|
            vb.name = "registry"
            vb.cpus = 2
            vb.memory = 4096
        end
        img.vm.network "private_network", ip: "192.168.77.12"
        img.vm.network "public_network"
        img.vm.provision "shell", inline: <<-SCRIPT
            sudo apt-get -yqq update && sudo apt-get -yqq install nginx
        SCRIPT
    end
    
    config.vm.define "wn1" do |wn1|
        wn1.vm.hostname = "kube-worker-node1"
        wn1.vm.provider "virtuaimageox" do |vb|
            vb.name = "kube-worker-node1"
            vb.cpus = 4
            vb.memory = 4096
        end
        wn1.vm.network "private_network", ip: "192.168.10.12"
        wn1.vm.provision "shell", inline: <<-SCRIPT
        mkdir -p /home/vagrant/shell/
        sudo cp -r /vagrant/shell/3-kube-nodes/. /home/vagrant/shell/
        /bin/bash /home/vagrant/shell/nodes-full-upgrade.sh
        SCRIPT
    end
    
    config.vm.define "wn2" do |wn2|
        wn2.vm.hostname = "kube-worker-node2"
        wn2.vm.provider "virtuaimageox" do |vb|
            vb.name = "kube-worker-node2"
            vb.cpus = 4
            vb.memory = 4096
        end
        wn2.vm.network "private_network", ip: "192.168.10.13"
        wn2.vm.provision "shell", inline: <<-SCRIPT
            mkdir -p /home/vagrant/shell/
            sudo cp -r /vagrant/shell/3-kube-nodes/. /home/vagrant/shell/
            /bin/bash /home/vagrant/shell/nodes-full-upgrade.sh
        SCRIPT
    end
    
end