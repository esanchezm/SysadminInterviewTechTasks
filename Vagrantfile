# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.3"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.username = "vagrant"

  config.vm.define "techvm", autostart: true, primary:true do |techvm|
      techvm.vm.box = "ubuntu1404"
      techvm.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

      techvm.vm.network :private_network, ip: "172.16.2.12"

      config.vm.synced_folder ".", "/home/ubuntu/techtask"

      techvm.vm.provider "virtualbox" do |v|
         v.gui = false
         v.customize ["modifyvm", :id, "--memory", 1024]
         v.customize ["modifyvm", :id, "--cpus", 2]
      end

      techvm.vm.hostname = "techtask"

      techvm.vm.provision :chef_solo do |chef|
          chef.add_role('techtask/breakfix')
          chef.environment = 'development'

          chef.cookbooks_path = ["part02/chef/cookbooks","part02/chef/knife-cookbooks"]
          chef.roles_path = "part02/chef/roles"
          chef.environments_path = "part02/chef/environments"
          chef.data_bags_path = "part02/chef/data_bags"

          chef.log_level = :fatal
          chef.verbose_logging = false
          chef.formatter = :null
      end
  end
end
