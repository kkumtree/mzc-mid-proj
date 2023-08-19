# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"

    config.vm.define "ctr" do |ctrl|
        ctrl.vm.hostname = "kube-controller"
        ctrl.vm.provider "virtualbox" do |vb|
            vb.name = "kube-control"
            vb.cpus = 4
            vb.memory = 8192
        end
        ctrl.vm.network "private_network", ip: "192.168.17.101"
        ctrl.vm.provision "shell", 
            inline: "/bin/bash /vagrant/shell/common/vagrant.sh ctrl"
    end

    config.vm.define "wn1" do |wn1|
        wn1.vm.hostname = "kube-worker-node1"
        wn1.vm.provider "virtualbox" do |vb|
            vb.name = "kube-worker-node1"
            vb.cpus = 4
            vb.memory = 4096
        end
        wn1.vm.network "private_network", ip: "192.168.17.102"
        wn1.vm.provision "shell",
            inline: "/bin/bash /vagrant/shell/common/vagrant.sh node"
    end
    
    config.vm.define "wn2" do |wn2|
        wn2.vm.hostname = "kube-worker-node2"
        wn2.vm.provider "virtualbox" do |vb|
            vb.name = "kube-worker-node2"
            vb.cpus = 4
            vb.memory = 4096
        end
        wn2.vm.network "private_network", ip: "192.168.17.103"
        wn2.vm.provision "shell",
            inline: "/bin/bash /vagrant/shell/common/vagrant.sh node"
    end
    
    # nginx LB 기능 활용해서 NodePosrt 로 공개된 모든 노드에 서비스 배포
    config.vm.define "nginx-lb" do |lb|
        lb.vm.hostname = "nginx-lb"
        lb.vm.provider "virtualbox" do |vb|
            vb.name = "nginx-lb"
            vb.cpus = 2
            vb.memory = 4096
        end
        lb.vm.network "private_network", ip: "192.168.10.14"
        lb.vm.network "public_network"
        lb.vm.provision "shell", inline: <<-SCRIPT
            sudo apt-get -yqq update && sudo apt-get -yqq install nginx
        SCRIPT
    end
end