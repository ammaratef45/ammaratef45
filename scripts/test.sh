#!/bin/bash

set -e

echo "Instance is healthy" > /var/www/html/health.html

# Loader.io verify ownership
IO=loaderio-f852153bc07b866f211a343ba53a26e2
echo "$IO" > /var/www/html/$IO.html

# Adsense
echo "google.com, pub-5308838739950508, DIRECT, f08c47fec0942fa0" > /var/www/html/ads.txt
