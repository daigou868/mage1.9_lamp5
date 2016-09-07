#!/usr/bin/env bash
echo "Enter password:"; read DJpass

apt -y update
apt -y upgrade
apt-get dist-upgrade

echo "Asia/Hong_Kong" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

apt -y install ntp
timedatectl set-timezone Asia/Hong_Kong
sed -i 's/ubuntu.pool.ntp.org/asia.pool.ntp.org/g' /etc/ntp.conf
service ntp restart

apt -y install apache2 php5 php5-common libapache2-mod-php5 php5-mcrypt php5-cgi php5-cli php5-curl php5-gd php5-mysql libcurl3 php5-curl php5-gd php5-mcrypt git php-soap

echo "ServerName 868daigou.cn.com" | sudo tee /etc/apache2/conf-available/fqdn.conf

sed -i 's/index.html index.cgi index.pl index.php/index.php index.html index.cgi index.pl/g' /etc/apache2/mods-enabled/dir.conf

wget https://raw.githubusercontent.com/daigou868/mage1.9_lamp5/master/magento.conf -O /etc/apache2/sites-available/magento.conf

a2dissite 000-default
a2ensite magento

a2enconf fqdn
a2enmod rewrite
php5enmod mcrypt

#rm -rf /var/www/html/*

wget https://github.com/OpenMage/magento-mirror/archive/1.9.2.4.tar.gz
tar -xvzf 1.9.2.4.tar.gz
sudo rsync -avP /root/magento-mirror-1.9.2.4/. /var/www/html/

#chmod 644 /var/www/html/.htaccess

for r in $(find / -name "php.ini"); do
sed -i 's/memory_limit = 128M/memory_limit = 512M/g' $r;
done

for i in $(find / -name "php.ini"); do
echo "/etc/php5/cli/php.ini
/etc/php5/cgi/php.ini
/etc/php5/apache2/php.ini" >> $i;
done

chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 770 {} \;
find /var/www/html/ -type f -exec chmod 660 {} \;

service apache2 restart

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
#/opt/letsencrypt/letsencrypt-auto --apache -d 868daigou.cn.com -d www.868daigou.cn.com

useradd -m danijeljames -s /bin/bash
echo "danijeljames:$DJpass" | chpasswd
usermod -aG sudo,www-data danijeljames
