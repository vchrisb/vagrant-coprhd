# -*- mode: ruby -*-
# vi: set ft=ruby :

# CoprHD IP Address using a host only network
node_ip = "192.168.100.11"
virtual_ip = "192.168.100.10"

# we are using the vagrant host IP as GW
gw_ip = "192.168.100.1"

# build CoprHD from sources
build = true

Vagrant.configure(2) do |config|

  # try to enable caching to speed up package installation for second run
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # using a minimal OpenSUSE 13.2 64Bit box
  # Packer Template can be found here: https://github.com/vchrisb/packer-templates
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

  config.vm.provider "vmware_fusion" do |v|
   v.gui = false
   v.vmx["displayname"] = "CoprHD1"
   v.vmx["memsize"] = 8192
   v.vmx["numvcpus"] = 2
   v.vmx["cpuid.coresPerSocket"] = 2
  end

  # install necessary packages
  config.vm.provision "packages", type: "shell" do |s|
   s.path = "scripts/packages.sh"
   s.args   = "--build #{build}"
  end

  # donwload, patch and build nginx
  config.vm.provision "nginx", type: "shell", path: "scripts/nginx.sh"

  # create CoprHD configuration file
  config.vm.provision "config", type: "shell" do |s|
   s.path = "scripts/config.sh"
   s.args   = "--node_ip #{node_ip} --virtual_ip #{virtual_ip} --gw_ip #{gw_ip} --node_count 1 --node_id vipr1"
  end

  # download and compile CoprHD from sources
  config.vm.provision "build", type: "shell" do |s|
   s.path = "scripts/build.sh"
   s.args   = "--build #{build}"
  end

  # install CoprHD RPM
  config.vm.provision "install", type: "shell" do |s|
   s.path = "scripts/install.sh"
   s.args   = "--virtual_ip #{virtual_ip}"
  end

end
2
