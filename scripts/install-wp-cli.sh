#!/bin/bash

set -e
source /usr/sys-vars

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp
wp cli update
curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.6.0/utils/wp-completion.bash
mv wp-completion.bash /usr/bin/
echo "source /usr/bin/wp-completion.bash" >> /home/ec2-user/.bashrc
