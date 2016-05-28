# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
params = YAML.load_file('rpm.yaml')

Vagrant.configure(2) do |config|
#  config.vm.box = "bento/centos-6.7"
#  config.vm.box_check_update = false
  params.each do |params|
    config.vm.define params["hostname"] do |dev|
      dev.vm.box = params["vm_box"]
      dev.vm.box_check_update = false
      dev.vm.provision "shell" do |s|
        s.path = params["script"]
        s.args =[
          params["spec"],
          params["srpm"],
          params["repo"],
          params["scm"],
          params["scm_dir"]]
      end
    end
  end
end
