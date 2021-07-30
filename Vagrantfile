# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox"

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.ssh.forward_agent = false
  config.ssh.insert_key = false
  # Timeouts
  config.vm.graceful_halt_timeout=30


  config.vm.define :WindowsServer2016, primary: true, autostart: true do |win2016|
    win2016.vm.boot_timeout = 3600
    win2016.vm.box =  "jborean93/WindowsServer2016"
    win2016.vm.communicator = "winrm"
    win2016.vm.guest = :windows
    win2016.vm.hostname = "WindowsServer2016"
    win2016.vm.network :forwarded_port, guest: 22, host: 2216, id: 'ssh', auto_correct: true
    win2016.vm.network :forwarded_port, guest: 3389, host: 3389, id: 'rdp', auto_correct: true
    win2016.vm.network :forwarded_port, guest: 5985, host: 5985, id: 'winrm', auto_correct: false
    win2016.vm.network :forwarded_port, guest: 5986, host: 5986, id: 'winrms', auto_correct: false
    win2016.vm.network "private_network", ip: "10.0.3.16", :netmask => "255.255.255.0",  auto_config: true
    win2016.winrm.password = "vagrant"
    win2016.winrm.username = "vagrant"
    win2016.vm.provider "virtualbox" do |vb|
      vb.default_nic_type = "virtio"
      vb.cpus = 4
      vb.customize [
        "modifyvm", :id,
        "--memory", "4096",
        "--natdnshostresolver1", "on",
        "--cableconnected1", "on",
      ]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
      vb.gui = true
      vb.name = "WindowsServer2016"
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "playbook.yml"
    ansible.galaxy_role_file = "roles/requirements.yml"
    ansible.galaxy_roles_path = "roles"
    ansible.verbose = "vv"
  end
end
