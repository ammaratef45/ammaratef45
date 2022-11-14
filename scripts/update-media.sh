#!/bin/bash

set -e
source /usr/sys-vars
cd /var/www/html

mysql -h $DBEndpoint -u $DBUser --password=$DBPassword -e "DELETE FROM $DBName.wp_postmeta WHERE meta_key=\"_wp_attached_file\" or meta_key=\"_wp_attachment_metadata\";"
mysql -h $DBEndpoint -u $DBUser --password=$DBPassword -e "DELETE FROM $DBName.wp_posts WHERE post_type=\"attachment\";"
yes | rm -rf wp-content/uploads/*
aws s3 sync s3://wordpresspublicimages images
wp media import images/**\/*.jpg || true
wp media import images/**\/*.jpeg || true
wp media import images/**\/*.png || true
wp media import images/*.jpg || true
wp media import images/*.jpeg || true
wp media import images/*.png || true
yes | rm -rf images
