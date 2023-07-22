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

# Setup TLS
aws secretsmanager get-secret-value --region us-east-1 --secret-id cdn-private-key --query 'SecretString' --output text | base64 -d > /etc/pki/tls/private/cdn.ammaratef45.key
aws secretsmanager get-secret-value --region us-east-1 --secret-id cdn-public-crt --query 'SecretString' --output text | base64 -d > /etc/pki/tls/certs/cdn.ammaratef45.crt
aws secretsmanager get-secret-value --region us-east-1 --secret-id cdn-chain --query 'SecretString' --output text | base64 -d > /etc/pki/tls/certs/cdn.ammaratef45.ca-bundle
yes | rm /etc/httpd/conf.d/ssl.conf
cp /var/www/html/scripts/ssl.conf /etc/httpd/conf.d/
service httpd restart
