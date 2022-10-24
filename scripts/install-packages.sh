#!/bin/bash

set -e

# Wordpress
amazon-linux-extras enable php7.4
yum update -y
yum upgrade -y
yum install -y php php-mysqlnd mariadb mariadb-devel mariadb-libs \
httpd mod_ssl php-dom php-imagick php-mbstring php-intl ruby
