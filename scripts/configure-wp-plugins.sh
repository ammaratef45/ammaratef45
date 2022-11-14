#!/bin/bash

set -e
source /usr/sys-vars

sed -i "/^.*WP_DEBUG.*/a define('WPCOM_API_KEY','$AkismetKey');" /var/www/html/wp-config.php
sed -i "/^.*WP_DEBUG.*/a define('WP_CACHE',true);" /var/www/html/wp-config.php
sed -i "/^.*WP_DEBUG.*/a define('WPCACHEHOME','/var/www/html/wp-content/plugins/wp-super-cache/');" /var/www/html/wp-config.php
cp /var/www/html/scripts/advanced-cache.php /var/www/html/wp-content/
cp /var/www/html/scripts/wp-cache-config.php /var/www/html/wp-content/
chmod 777 /var/www/html/wp-content/wp-cache-config.php
mkdir /var/www/html/wp-content/cache
chmod 777 /var/www/html/wp-content/cache
service httpd restart
