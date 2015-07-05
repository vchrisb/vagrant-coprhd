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

# VM requirements
memory = 8192
cpus = 4
vm_name = 'CoprHD'

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
  config.vm.provider :virtualbox do |virtualbox|
   virtualbox.gui = false
   virtualbox.name = vm_name
   virtualbox.memory = memory
   virtualbox.cpus = cpus
  end

  # configure VMware Fusion provider
  config.vm.provider :vmware_fusion do |fusion|
   fusion.gui = false
   fusion.vmx["displayname"] = vm_name
   fusion.vmx["memsize"] = memory
   fusion.vmx["numvcpus"] = cpus
   fusion.vmx["cpuid.coresPerSocket"] = 1
   config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  # configure VMware AppCatalyst provider
  # https://github.com/vmware/vagrant-vmware-appcatalyst
  config.vm.provider 'vmware_appcatalyst' do |v|
    v.cpus = cpus
    v.memory = memory
  end
  
  # configure vCloud Air provider
  # https://github.com/gosddc/vagrant-vcloudair
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
    vcloudair.memory = memory
    vcloudair.cpus = cpus
  end

  # configure vCenter provider
  # https://github.com/gosddc/vagrant-vcenter
  config.vm.provider :vcenter do |vcenter|
   vcenter.hostname = settings['vcenter']['hostname']
   vcenter.username = settings['vcenter']['username']
   vcenter.password = settings['vcenter']['password']
   vcenter.folder_name = settings['vcenter']['folder_name']
   vcenter.datacenter_name = settings['vcenter']['datacenter_name']
   vcenter.computer_name = vm_name
   vcenter.datastore_name = settings['vcenter']['datastore_name']
   vcenter.network_name = settings['vcenter']['network_name']
   vcenter.linked_clones = true
   vcenter.memory = memory
   vcenter.num_cpu = cpus
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