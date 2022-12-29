#!/bin/bash

set -e
source /usr/sys-vars

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" /var/www/html/wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" /var/www/html/wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" /var/www/html/wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" /var/www/html/wp-config.php

# add s3 creds to config file
ACCESS_KEY=$(aws secretsmanager get-secret-value --secret-id media-access-keyid --region us-east-1 --query "SecretString" --output text | cut -d : -f 2 | cut -d \" -f 2)
SECRET_KEY=$(aws secretsmanager get-secret-value --secret-id media-access-keyid --region us-east-1 --query "SecretString" --output text | cut -d : -f 3 | cut -d \" -f 2)
echo "
define('AS3CF_SETTINGS', serialize(array(
  'provider' => 'aws',
  'access-key-id' => '$ACCESS_KEY',
  'secret-access-key' => '$SECRET_KEY',
)));
" > credfile.txt
sed -i "/define( 'WP_DEBUG', false );/r credfile.txt" /var/www/html/wp-config.php
