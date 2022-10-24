#!/bin/bash

set -e

source /usr/sys-vars

wget http://wordpress.org/latest.tar.gz
tar -xf latest.tar.gz
mv wordpress/* /var/www/html

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" /var/www/html/wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" /var/www/html/wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" /var/www/html/wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" /var/www/html/wp-config.php
# enable spamming api
sed -i "/^.*WP_DEBUG.*/a define('WPCOM_API_KEY','$AkismetKey');" /var/www/html/wp-config.php
# enable w3 cache
sed -i "/^.*WP_DEBUG.*/a define('WP_CACHE',true);" /var/www/html/wp-config.php
sed -i "s/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks/g" /etc/httpd/conf/httpd.conf
sed -i "s/AllowOverride None/AllowOverride FileInfo/g" /etc/httpd/conf/httpd.conf

# .htaccess file (enable text compression and w3 cache plugin)
echo "LoadModule deflate_module modules/mod_deflate.so" >> /etc/httpd/conf/httpd.conf
sed -i "/^.*WP_USE_THEMES.*/a ob_start(\"ob_gzhandler\");" /var/www/html/index.php
service httpd restart

# Install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp
wp cli update
curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.6.0/utils/wp-completion.bash
mv wp-completion.bash /usr/bin/
source /usr/bin/wp-completion.bash
cd /var/www/html

# download images
aws s3 sync s3://wordpresspublicimages images
wp media import images/**\/*.jpg
yes | rm -rf images


# wp-cli plugins
wp plugin update akismet
wp theme delete twentytwenty
wp theme delete twentytwentyone
wp plugin install google-site-kit
wp plugin install w3-total-cache
wp plugin install wordpress-seo
# enable page cache
sed -i "s/\"pgcache.enabled\": false/\"pgcache.enabled\": true/g" /var/www/html/wp-config.php

cp /var/www/html/wp-content/plugins/w3-total-cache/wp-content/advanced-cache.php /var/www/html/wp-content/advanced-cache.php
mkdir /var/www/html/wp-content/cache
chmod 777 /var/www/html/wp-content/cache
mkdir /var/www/html/wp-content/w3tc-config
chmod 777 /var/www/html/wp-content/w3tc-config
service httpd restart
