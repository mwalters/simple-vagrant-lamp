#ensure host sync folders exist before vagrant up
def ensure_sync_folder(dirname)
  if !File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end
end

ensure_sync_folder('www')
ensure_sync_folder('sqldump')
ensure_sync_folder('scripts')

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "192.168.56.101"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "precise64"]
  end

  config.vm.synced_folder "/Users/mwalters/www", "/var/www"
  config.vm.synced_folder "/Users/mwalters/sqldump", "/var/sqldump"
  config.vm.synced_folder "/Users/mwalters/scripts", "/var/scripts"

  config.vm.provision :shell, :path => "bootstrap.sh"
end
