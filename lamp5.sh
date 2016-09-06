#!/usr/bin/env bash
apt -y install 

apt -y install apache2 php5 libapache2-mod-php5 php5-mcrypt php5-cgi php5-cli php5-common php5-curl php5-gd php5-mysql



sed -i 's/index.html index.cgi index.pl index.php/index.php index.html index.cgi index.pl/g' /etc/apache2/mods-enabled/dir.conf



a2enmod rewrite



wget https://github.com/OpenMage/magento-mirror/archive/1.9.2.4.tar.gz
tar -xvzf community_images.tar.gz
magento-mirror-1.9.2.4



/etc/php5/cli/php.ini
/etc/php5/cgi/php.ini
/etc/php5/apache2/php.ini
