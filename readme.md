# Simple Vagrant LAMP box

## Features
- Simple administration. This script doesn't require the learning curve of Puppet or Chef, though I recommend you looking into either of those solutions. Instead, it uses a simple shell script to install packages and import the database.
- VM Description
	- 1GB RAM
	- Ubuntu 14.04 LTS (trusty)
	- Apache w/ mod_rewrite
	- MySQL
	- PHP
	- Pear
	- [MailCatcher](http://mailcatcher.me/)
	- MySQL database named `devdb` and a username of `devdb` having access to it with the password `devdb`

## Setup
The `Vagrantfile` shares 4 folders from your host machine into your VM: `./www`, `./sqldump`, `./scripts`, and `./custom_config/files`. If these folders don't exist they will be created when `vagrant up` is run. It is recommended to symlink folders from your current project to these in the vagrant folder and then you can change the symlinks to move between projects - e.g. `ln -fs ~/Sites/dev ./www`. You can do this either before or after `vagrant up`.

These folders are used as follows:
- www
	- This is the web root of the website you want hosted in the VM
- sqldump
	- This is where the database SQL file is stored. Initially it's fine for this to be empty, but if you destory the VM, a sqldump file located here will be imported into the VM's database when it is created. The file should be named `database.sql`
- scripts
	- There is a shell script file called `dumpdb.sh` located here. It can be run from within the vagrant machine (`vagrant ssh` to log in) in order to create a `database.sql` file which can be used for re-importing a database when creating the virtual machine.  You can locate any scripts here that you would like to have available within the virutal machine.
- custom_config_files
	- Inside of here, by default, is an apache2 directory containing the file `default`.  This file is the default virtual host file.  So you can alter it to align with your needs for the site you are attempting to host in the virtual machine.

When you first boot the VM or recreate it, you might see some warning messages from apache about not being able to determine the ServerName. The bootstrap file eventually fixes this as it goes through its process.

Edit your local hosts file to point a domain to `192.168.56.101` then use that domain in your browser to hit the site your VM is serving.

## What is the bootstrap.sh script doing?
- This file is only run when the virtual machine is initially created or recreated after a `vagrant destroy`
- Sets the MySQL root password to `root`
- Updates software on the VM
- Installs necessary packages
- Sets the timezone on the machine to `America/New_York`
- Deletes the `test` database in MySQL
- Creates the `devdb` MySQL database and user
- Sets ServerName for Apache to keep it from complaining
- Enables mod_rewrite
- Places the default Apache virtual host file
- Install MailCatcher
- Sets PHP configuration values:
	- Send mail via MailCatcher
	- Turns on `display_errors`
	- Turns on `error_reporting` and sets to development values (display everything)
	- Turns on `html_errors`
- Starts MailCatcher
- Restarts Apache

## What is the load.sh script doing?
- This file is run every time the virtual machine is started from a `vagrant up`
- Imports `database.sql` into the `devdb` database if the file exists

## Using MailCatcher
- Load [http://192.168.56.101:1080/](http://192.168.56.101:1080/) in your browser to view the MailCatcher interface

## What is MailCatcher?
Check out the [MailCatcher](http://mailcatcher.me/) homepage, but the short description is that it catches email being sent and let's you view it via a web interface (port 1080 on the VM). This way you don't have to actually send email through the internet and wait for it to be delivered, etc. You can check the queue with your browser easily and clear it whenever you'd like. This also means that you could make your VM send thousands of emails (intentionally or unintentionally) and easily see if they would have been delivered.
