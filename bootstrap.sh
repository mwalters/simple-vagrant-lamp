# Set MySQL root password
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'

# Install packages
apt-get update
apt-get -y install mysql-server-5.5 php5-mysql libsqlite3-dev apache2 php5 php5-dev build-essential php-pear ruby1.9.1-dev

# Set timezone
echo "America/New_York" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Setup database
echo "DROP DATABASE IF EXISTS test" | mysql -uroot -proot
echo "CREATE USER 'devdb'@'localhost' IDENTIFIED BY 'devdb'" | mysql -uroot -proot
echo "CREATE DATABASE devdb" | mysql -uroot -proot
echo "GRANT ALL ON devdb.* TO 'devdb'@'localhost'" | mysql -uroot -proot
echo "FLUSH PRIVILEGES" | mysql -uroot -proot

# Apache changes
echo "ServerName localhost" >> /etc/apache2/apache2.conf
a2enmod rewrite
cat /var/custom_config_files/apache2/default | tee /etc/apache2/sites-available/000-default.conf

# Install Mailcatcher
echo "Installing mailcatcher"
gem install mailcatcher --no-ri --no-rdoc
mailcatcher --http-ip=192.168.56.101

# Configure PHP
sed -i '/;sendmail_path =/c sendmail_path = "/usr/local/bin/catchmail"' /etc/php5/apache2/php.ini
sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
sed -i '/html_errors = Off/c html_errors = On' /etc/php5/apache2/php.ini

# Make sure things are up and running as they should be
service apache2 restart
