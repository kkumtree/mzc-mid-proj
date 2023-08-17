# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"

    config.vm.define "pipe" do |pipe|
        pipe.vm.hostname = "jenkins"
        pipe.vm.provider "virtualbox" do |vb|
            vb.name = "jenkins"
            vb.cpus = 4
            vb.memory = 8192
        end
        pipe.vm.network "private_network", ip: "192.168.17.101"
        pipe.vm.network "public_network"
        pipe.vm.provision "shell", 
        inline: "/bin/bash /vagrant/shell/common/vagrant.sh pipe" 
    end

    config.vm.define "img" do |img|
        img.vm.hostname = "registry"
        img.vm.provider "virtualbox" do |vb|
            vb.name = "registry"
            vb.cpus = 2
            vb.memory = 4096
        end
        img.vm.network "private_network", ip: "192.168.17.102"
        img.vm.network "public_network"
        img.vm.provision "shell", 
        inline: "/bin/bash /vagrant/shell/common/vagrant.sh img"
    end 

    config.vm.define "nfs" do |nfs|
        nfs.vm.hostname = "storage"
        nfs.vm.provider "virtualbox" do |vb|
            vb.name = "storage"
            vb.cpus = 2
            vb.memory = 4096
        end
        nfs.vm.network "private_network", ip: "192.168.17.103"
        nfs.vm.network "public_network"
        nfs.vm.provision "shell", 
        inline: "/bin/bash /vagrant/shell/common/vagrant.sh nfs"
    end
    
    config.vm.define "frontend" do |front|
        front.vm.hostname = "frontend"
        front.vm.provider "virtualbox" do |vb|
            vb.name = "frontend"
            vb.cpus = 2
            vb.memory = 4096
        end
        front.vm.network "private_network", ip: "192.168.17.104"
        front.vm.network "public_network"
        front.vm.provision "shell", 
        inline: "/bin/bash /vagrant/shell/common/vagrant.sh front"
    end

end