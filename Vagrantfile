Vagrant.configure("2") do |config|
  config.ssh.username = 'root'
  config.ssh.password = 'root'
  config.ssh.insert_key = 'true'
  config.vm.define :docker1 do |docker1|
    docker1.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--name", "docker1", "--memory", "512"]
    end
    docker1.vm.box = "centos7"
    docker1.vm.hostname = "docker1.node"
    docker1.vm.network :public_network, ip: "192.168.1.11"
  end

  config.vm.define :docker2 do |docker2|
    docker2.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--name", "docker2", "--memory", "512"]
    end
    docker2.vm.box = "centos7"
    docker2.vm.hostname = "docker2.node"
    docker2.vm.network :public_network, ip: "192.168.1.12"
  end

  config.vm.define :docker3 do |docker3|
    docker3.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--name", "docker3", "--memory", "512"]
    end
    docker3.vm.box = "centos7"
    docker3.vm.hostname = "docker3.node"
    docker3.vm.network :public_network, ip: "192.168.1.13"
  end

  config.vm.define :docker4 do |docker4|
    docker4.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--name", "docker4", "--memory", "512"]
    end
    docker4.vm.box = "centos7"
    docker4.vm.hostname = "docker4.node"
    docker4.vm.network :public_network, ip: "192.168.1.14"
  end
end
