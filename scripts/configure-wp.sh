#!/bin/bash

set -e
source /usr/sys-vars

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" /var/www/html/wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" /var/www/html/wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" /var/www/html/wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" /var/www/html/wp-config.php
