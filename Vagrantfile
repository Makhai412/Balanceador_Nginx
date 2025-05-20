Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end

  # Ruta a scripts
  SCRIPTS_PATH = "scripts"

  # Balanceador
  config.vm.define "balancer" do |balancer|
    balancer.vm.box = "bento/ubuntu-22.04"
    balancer.vm.network "private_network", ip: "192.168.50.30"
    balancer.vm.hostname = "balancer"
    balancer.vm.provision "shell", path: "#{SCRIPTS_PATH}/provision-balancer.sh"
  end

  # Cliente
  config.vm.define "cliente" do |cliente|
    cliente.vm.box = "bento/ubuntu-22.04"
    cliente.vm.network "private_network", ip: "192.168.60.30"
    cliente.vm.hostname = "cliente"
    cliente.vm.provision "shell", path: "#{SCRIPTS_PATH}/provision-cliente.sh"
  end

  #Web1
  config.vm.define :web1 do |web1|
    web1.vm.box = "bento/ubuntu-22.04"
    web1.vm.hostname = "web1"
    web1.vm.network "private_network", ip: "192.168.50.10"
   web1.vm.provision "shell", path: "#{SCRIPTS_PATH}/provision-web.sh", privileged: false, run: "always", binary: "bash"
  end

  #Web2
  config.vm.define :web2 do |web2|
    web2.vm.box = "bento/ubuntu-22.04"
    web2.vm.hostname = "web2"
    web2.vm.network "private_network", ip: "192.168.50.20"
   web2.vm.provision "shell", path: "#{SCRIPTS_PATH}/provision-web.sh", privileged: false, run: "always", binary: "bash"
  end
  # Web3
  config.vm.define :web3 do |web3|
    web3.vm.box = "bento/ubuntu-22.04"
    web3.vm.hostname = "web3"
    web3.vm.network "private_network", ip: "192.168.50.11"
    web3.vm.provision "shell", path: "#{SCRIPTS_PATH}/provision-web.sh", privileged: false, run: "always", binary: "bash"
  end

  # Web4
  config.vm.define :web4 do |web4|
    web4.vm.box = "bento/ubuntu-22.04"
    web4.vm.hostname = "web4"
    web4.vm.network "private_network", ip: "192.168.50.12"
    web4.vm.provision "shell", path: "#{SCRIPTS_PATH}/provision-web.sh", privileged: false, run: "always", binary: "bash"
  end
  
end