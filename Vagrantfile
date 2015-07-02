# -*- mode: ruby -*-
# vi: set ft=ruby :

#load sensitive date
require 'yaml'
settings = YAML.load_file 'vagrant.yml'

# CoprHD IP Address using a host only network
node_ip = "192.168.100.11"
virtual_ip = "192.168.100.10"

# we are using the vagrant host IP as GW
gw_ip = "192.168.100.1"

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # using a minimal OpenSUSE 13.2 64Bit box
  # Packer Template can be found here: https://github.com/vchrisb/packer-templates
  # config.vm.box = "webhippie/opensuse-13.2"
  config.vm.box = "vchrisb/openSUSE-13.2_64"
  
  # Set up hostname
  config.vm.hostname = "coprhd1.lab.local"
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "#{node_ip}"

  # configure virtualbox provider
  config.vm.provider "virtualbox" do |v|
   v.gui = false
   v.name = "CoprHD1"
   v.memory = 8192
   v.cpus = 4
  end

  # configure VMware Fusion provider
  config.vm.provider "vmware_fusion" do |v|
   v.gui = false
   v.vmx["displayname"] = "CoprHD1"
   v.vmx["memsize"] = 8192
   v.vmx["numvcpus"] = 2
   v.vmx["cpuid.coresPerSocket"] = 2
   config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  # configure vCloud Air provider
  config.vm.provider :vcloudair do |vcloudair|
	# username and password
    vcloudair.username = settings['vcloudair']['username']
    vcloudair.password = settings['vcloudair']['password']

    # if you're using a vCloud Air Dedicated Cloud, put the cloud id here, if
    # you're using a Virtual Private Cloud, skip this parameter.
    #vcloudair.cloud_id = '<dedicated cloud id>'
    vcloudair.vdc_name = settings['vcloudair']['vdc_name']

    # Set the network to deploy our VM on (case sensitive)
    vcloudair.vdc_network_name = settings['vcloudair']['vdc_network_name']

    # Set our Edge Gateway and the public IP we're going to use.
    vcloudair.vdc_edge_gateway = settings['vcloudair']['vdc_edge_gateway']
    vcloudair.vdc_edge_gateway_ip = settings['vcloudair']['vdc_edge_gateway_ip']

    # Catalog that holds our templates.
    vcloudair.catalog_name = settings['vcloudair']['catalog_name']

    # Set our Memory and CPU to a sensible value for Docker.
    vcloudair.memory = 8192
    vcloudair.cpus = 2	
  end

  # configure vCenter provider
  config.vm.provider "vcenter" do |v|
   v.hostname = settings['vcenter']['hostname']
   v.username = settings['vcenter']['username']
   v.password = settings['vcenter']['password']
   v.folder_name = settings['vcenter']['folder_name']
   v.datacenter_name = settings['vcenter']['datacenter_name']
   v.computer_name = settings['vcenter']['computer_name']
   v.datastore_name = settings['vcenter']['datastore_name']
   v.network_name = settings['vcenter']['network_name']
   v.linked_clones = true
   v.memory = 8192
   v.num_cpu = 4
   config.vm.synced_folder ".", "/vagrant", disabled: true
  end
  
  # install necessary packages
  config.vm.provision "packages", type: "shell", path: "packages.sh"	
  
  # donwload, patch and build nginx
  config.vm.provision "nginx", type: "shell", path: "nginx.sh"	
  
  # create CoprHD configuration file
  config.vm.provision "config", type: "shell" do |s|
   s.path = "config.sh"
   s.args   = "--node_ip #{node_ip} --virtual_ip #{virtual_ip} --gw_ip #{gw_ip} --node_count 1 --node_id vipr1"
  end
  
  # download and compile CoprHD from sources
  config.vm.provision "build", type: "shell", path: "build.sh"
  
  # install CoprHD RPM
  config.vm.provision "install", type: "shell", path: "install.sh"

end
2