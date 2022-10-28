#!/bin/bash

set -e

echo "Instance is healthy" > /var/www/html/health.html

# Loader.io verify ownership
IO=loaderio-f852153bc07b866f211a343ba53a26e2
echo "$IO" > /var/www/html/$IO.html