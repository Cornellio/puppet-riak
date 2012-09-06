# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

Vagrant::Config.run do |config|
  # give all nodes a little bit more memory:
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  # choices for virtual machines:
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  #config.vm.box = 'debian-6.0'
  #config.vm.box_url = 'http://puppetlabs.s3.amazonaws.com/pub/Squeeze64.box'
  #config.vm.box = 'centos-6.3-64bit'
  #config.vm.box_url = 'https://dl.dropbox.com/u/7225008/Vagrant/CentOS-6.3-x86_64-minimal.box'

  config.vm.share_folder 'riak-module', "#{FileUtils.pwd}", "."

  # Plugins:
  config.hiera.config_path = './tests/config'
  config.hiera.config_file = 'vagrant-hiera.yaml'
  config.hiera.data_path   = './tests/data'

  config.vbguest.auto_update = false

  # specify puppet for provisioning
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = File.join 'spec', 'fixtures', 'manifests'
    puppet.module_path    = File.join 'spec', 'fixtures', 'modules'
    puppet.manifest_file  = 'vagrant-riak.pp'
    #puppet.options        = [ '--trace', '--debug', '--verbose' ]
  end

  # specify all Riak VMs:
  nodes = 3
  baseip = 5
  (1..nodes).each do |n|
    ip   = "10.42.0.#{baseip + n.to_i}"
    name = "riak-#{n}.local"
    config.vm.define name do |cfg|
      cfg.vm.host_name = name
      cfg.vm.network :hostonly, ip
    end
  end

  # for serving packages
  config.vm.define :"coroutine.local" do |cfg|
    cfg.vm.host_name = 'coroutine.local'
    cfg.vm.network :hostonly, "10.42.0.20"
    cfg.vm.customize ["modifyvm", :id, "--memory", 512]
  end
end
