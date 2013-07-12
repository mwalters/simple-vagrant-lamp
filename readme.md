# Simple Vagrant LAMP box

## Features
- Simple administration.  This script doesn't require the learning curve of Puppet or Chef, though I recommend you looking into either of those solutions.  Instead, it uses a simple shell script to install packages and import the database.
- VM Description
	- 1GB RAM
	- Ubuntu 12.04 LTS 64-bit
	- Apache w/ mod_rewrite
	- MySQL
	- PHP
	- Pear
	- XDebug
	- [MailCatcher](http://mailcatcher.me/)
	- MySQL database named `devdb` and a username of `devdb` having access to it with the password `devdb`

## Setup
Edit Vagrantfile to share the 3 folders form your host machine into your VM.  I recommend symlinking folders from your current project to these in your home folder.  Then you can just change the symlinks to move between projects.  If you don't really need a dev database you can probably remove the sqldump and scripts shared folders.

These 3 folders are:
- www
	- This is the root of the website you want hosted in the VM
- sqldump
	- This is where the database SQL file is stored.  Initially it's fine for this to be empty, but if you destory the VM, a sqldump file located here will be imported into the VM's database when it is created.  The file should be named `database.sql`
- scripts
	- This is where you can place various scripts that you might want access to.  A good example would be a script that can dump out the database and place it in the folder where the VM will look to import it from when it is being created.  See below section for an example command to dump the database.  You can run that script any time you want to update the backup of your database that will be restored when the VM is created.

When you first boot the VM or recreate it, you might see some warning messages from apache about not being able to determine the ServerName.  The bootstrap file eventually fixes this as it goes through its process.  There is also an rdoc notice that can be ignored.

Edit your local hosts file to point a domain to `192.168.56.101` then use that domain in your browser to hit the site your VM is serving.

## What is the bootstrap.sh script doing?
- Sets the MySQL root password to `root`
- Updates software on the VM
- Installs necessary packages
- Deletes the `test` database in MySQL
- Creates the `devdb` MySQL database and user
- Imports `database.sql` into the `devdb` database if the file exists
- Sets ServerName for Apach to keep it from complaining
- Enables mod_rewrite
- Allows use of .htaccess files
- Install MailCatcher
- Starts MailCatcher
- Installs XDebug
- Sets PHP configuration values:
	- Send mail via MailCatcher
	- Turns on `display_errors`
	- Turns on error reporting
	- Turns on HTML error reporting
	- Tells PHP about XDebug
- Restart Apache

## Creating the database dump file
In case you need some assistance, this command, run from inside the VM, will dump the `devdb` database into a file called `database.sql` and place it into `/var/sqldump/`

`mysqldump -uroot -proot devdb > /var/sqldump/database.sql`

## What is MailCatcher
Check out the link under VM Description for it.  But the short description is that it catches email being sent by PHP and let's you view it via a web interface (port 1080 on the VM).  This way you don't have to actually send email to yourself.  You can check the queue with your browser easily and clear it whenever you'd like.  You can even send thousands of emails and not worry about a provider getting mad at you, etc.  It's good stuff.
