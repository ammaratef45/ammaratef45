#!/bin/bash

set -e
source /usr/sys-vars

cd /var/www/html
wp plugin update akismet
wp theme delete twentytwenty
wp theme delete twentytwentyone
wp plugin install google-site-kit
wp plugin install wp-super-cache
wp plugin install wordpress-seo
wp plugin install amazon-s3-and-cloudfront
