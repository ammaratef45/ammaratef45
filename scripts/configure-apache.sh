#!/bin/bash

set -e
source /usr/sys-vars

sed -i "/^.*WP_USE_THEMES.*/a ob_start(\"ob_gzhandler\");" /var/www/html/index.php
echo "LoadModule deflate_module modules/mod_deflate.so" >> /etc/httpd/conf/httpd.conf
sed -i "s/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks/g" /etc/httpd/conf/httpd.conf
sed -i "s/AllowOverride None/AllowOverride FileInfo/g" /etc/httpd/conf/httpd.conf
touch /var/www/html/.htaccess
yes | rm /var/www/html/.htaccess
cp /var/www/html/scripts/.htaccess /var/www/html/
service httpd restart
