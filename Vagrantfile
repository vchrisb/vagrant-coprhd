# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# CoprHD IP Address using a host only network
node_ip = "192.168.100.11"
virtual_ip = "192.168.100.10"

# we are using the vagrant host IP as GW
gw_ip = "192.168.100.1"

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "webhippie/opensuse-13.2"

  # Set up hostname
  config.vm.hostname = "coprhd1.lab.local"
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "#{node_ip}"

  config.vm.provider "virtualbox" do |v|
   v.gui = false
   v.name = "CoprHD1"
   v.memory = 8192
   v.cpus = 4
  end

  config.vm.provider "vmware_fusion" do |v|
   v.gui = false
   v.vmx["displayname"] = "CoprHD1"
   v.vmx["memsize"] = 8192
   v.vmx["numvcpus"] = 2
   v.vmx["cpuid.coresPerSocket"] = 2
   config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
  config.vm.provision "nginx", type: "shell", path: "nginx.sh"
  config.vm.provision "config", type: "shell" do |s|
   s.path = "config.sh"
   s.args   = "--node_ip #{node_ip} --virtual_ip #{virtual_ip} --gw_ip #{gw_ip} --node_count 1 --node_id vipr1"
  end
  config.vm.provision "build", type: "shell", path: "build.sh"
  config.vm.provision "install", type: "shell", path: "install.sh"

end
2