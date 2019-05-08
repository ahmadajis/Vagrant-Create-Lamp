# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "lamp" do |lamp|
    lamp.vm.network :private_network, ip: "172.21.12.10"
    lamp.vm.box = "ubuntu/xenial64"
    lamp.vm.hostname = "lamp"
    lamp.vm.synced_folder "./html", "/var/www/html"
  end
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  config.vm.provision "shell" do |s|
    s.name = "install lamp-server"
    s.path = "provision.sh"
  end
end
