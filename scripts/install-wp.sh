#!/bin/bash

set -e
source /usr/sys-vars

wget http://wordpress.org/latest.tar.gz
tar -xf latest.tar.gz
mv wordpress/* /var/www/html
sh /var/www/html/scripts/configure-wp.sh
sh /var/www/html/scripts/configure-wp-plugins.sh
sh /var/www/html/scripts/configure-apache.sh
sh /var/www/html/scripts/install-wp-cli.sh
sh /var/www/html/scripts/install-wp-plugins.sh
sh /var/www/html/scripts/update-media.sh
