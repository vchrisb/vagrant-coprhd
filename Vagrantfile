# -*- mode: ruby -*-
# vi: set ft=ruby :

#load sensitive date
#require 'yaml'
#settings = YAML.load_file 'vagrant.yml'

# valid values 1,3,5
numNodes = 1

# CoprHD IP Address using a host only network
network = "192.168.100"
virtual_ip = "#{network}.10"

domain = "lab.local"
# we are using the vagrant host IP as GW
gw_ip = "#{network}.1"

# VM requirements
memory = 8192
cpus = 4

# build CoprHD from sources
build = true

Vagrant.configure(2) do |config|

  # try to enable caching to speed up package installation for second run
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  1.upto(numNodes) do |num|
      node_name = "coprhd#{num}"
      node_ip = "#{network}.1#{num}"

      config.vm.define node_name do |node|

          node.vm.box = "vchrisb/openSUSE-13.2_64"
          node.vm.hostname = "#{node_name}.#{domain}"
          node.vm.network :private_network, ip: node_ip
          node.vm.synced_folder "synced_folder/", "/vagrant"
          node.vm.provider :virtualbox do |virtualbox|
            virtualbox.gui = false
            virtualbox.name = node_name
            virtualbox.memory = memory
            virtualbox.cpus = cpus
          end
          # install necessary packages
          node.vm.provision "packages", type: "shell" do |s|
           s.path = "scripts/packages.sh"
           s.args   = "--build #{build}"
          end

          # donwload, patch and build nginx
          node.vm.provision "nginx", type: "shell", path: "scripts/nginx.sh"

          # create CoprHD configuration file
          node.vm.provision "config", type: "shell" do |s|
           s.path = "scripts/config.sh"
           s.args   = "--node_ip #{node_ip} --virtual_ip #{virtual_ip} --gw_ip #{gw_ip} --node_count #{numNodes} --node_id vipr#{num}"
          end

          if num == 1
            # download and compile CoprHD from sources
            node.vm.provision "build", type: "shell" do |s|
             s.path = "scripts/build.sh"
             s.args   = "--build #{build}"
            end
          end

          # install CoprHD RPM
          node.vm.provision "install", type: "shell", path: "scripts/install.sh"
      end

    end

  # configure VMware Fusion provider
  # config.vm.provider :vmware_fusion do |fusion|
  #  fusion.gui = false
  #  fusion.vmx["displayname"] = vm_name
  #  fusion.vmx["memsize"] = memory
  #  fusion.vmx["numvcpus"] = cpus
  #  fusion.vmx["cpuid.coresPerSocket"] = 1
  # end

  # configure VMware AppCatalyst provider
  # https://github.com/vmware/vagrant-vmware-appcatalyst
  # config.vm.provider 'vmware_appcatalyst' do |v|
  #   v.cpus = cpus
  #   v.memory = memory
  # end

  # install necessary packages
  #config.vm.provision "packages", type: "shell", path: "packages.sh"

  # donwload, patch and build nginx
  #config.vm.provision "nginx", type: "shell", path: "nginx.sh"

  # create CoprHD configuration file
  #config.vm.provision "config", type: "shell" do |s|
  # s.path = "config.sh"
  # s.args   = "--node_ip #{node_ip} --virtual_ip #{virtual_ip} --gw_ip #{gw_ip} --node_count 1 --node_id vipr1"
  #end

  # download and compile CoprHD from sources
  #config.vm.provision "build", type: "shell", path: "build.sh"

  # install CoprHD RPM
  #config.vm.provision "install", type: "shell", path: "install.sh"

end
2
