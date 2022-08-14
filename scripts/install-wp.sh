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
sed -i "/^.*WP_DEBUG.*/a define('WPCOM_API_KEY','$AkismetKey');" /var/www/html/wp-config.php
sed -i "s/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks/g" /etc/httpd/conf/httpd.conf
service httpd restart


# Install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp
wp cli update
curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.6.0/utils/wp-completion.bash
mv wp-completion.bash /usr/bin/
source /usr/bin/wp-completion.bash

# wp-cli plugins
cd /var/www/html
wp plugin activate akismet
wp plugin update akismet
wp plugin activate hello
wp theme delete twentytwenty
wp theme delete twentytwentyone