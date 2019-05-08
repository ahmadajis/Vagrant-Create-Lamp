#!/bin/bash

# Allow SSH Password Authentication
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd.service

# Update
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y

# Install MySQL
echo "mysql-server mysql-server/root_password password vagrant" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections
apt-get install -y mysql-server

# Install Apache & PHP
 apt-get install -y apache2 php libapache2-mod-php php-mcrypt php-mysql

# Install PHPMyAdmin
echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password vagrant" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password vagrant" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password vagrant" | debconf-set-selections
apt-get install -y phpmyadmin

# Securing Apache & PHP
sed -i -e 's/ServerTokens OS/ServerTokens Prod/g' /etc/apache2/conf-available/security.conf
sed -i -e 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-available/security.conf
sed -i -e 's/expose_php = On/expose_php = Off/g' /etc/php/7.0/cli/php.ini
systemctl restart apache2.service

# Remove unused package & files
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*