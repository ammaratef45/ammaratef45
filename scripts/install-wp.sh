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

# enable text compression
echo "LoadModule deflate_module modules/mod_deflate.so" >> /etc/httpd/conf/httpd.conf
echo "# GZIP compression for text files: HTML, CSS, JS, Text, XML, fonts
<IfModule mod_deflate.c>
AddOutputFilterByType DEFLATE text/html
AddOutputFilterByType DEFLATE text/css
AddOutputFilterByType DEFLATE text/javascript
AddOutputFilterByType DEFLATE text/xml
AddOutputFilterByType DEFLATE text/plain
AddOutputFilterByType DEFLATE image/x-icon
AddOutputFilterByType DEFLATE image/svg+xml
AddOutputFilterByType DEFLATE application/rss+xml
AddOutputFilterByType DEFLATE application/javascript
AddOutputFilterByType DEFLATE application/x-javascript
AddOutputFilterByType DEFLATE application/xml
AddOutputFilterByType DEFLATE application/xhtml+xml
AddOutputFilterByType DEFLATE application/x-font
AddOutputFilterByType DEFLATE application/x-font-truetype
AddOutputFilterByType DEFLATE application/x-font-ttf
AddOutputFilterByType DEFLATE application/x-font-otf
AddOutputFilterByType DEFLATE application/x-font-opentype
AddOutputFilterByType DEFLATE application/vnd.ms-fontobject
AddOutputFilterByType DEFLATE font/ttf
AddOutputFilterByType DEFLATE font/otf
AddOutputFilterByType DEFLATE font/opentype
# For Olders Browsers Which Can't Handle Compression
BrowserMatch ^Mozilla/4 gzip-only-text/html
BrowserMatch ^Mozilla/4\.0[678] no-gzip
BrowserMatch \bMSIE !no-gzip !gzip-only-text/html
</IfModule>
# BEGIN W3TC Browser Cache
<IfModule mod_mime.c>
    AddType text/css .css
    AddType text/x-component .htc
    AddType application/x-javascript .js
    AddType application/javascript .js2
    AddType text/javascript .js3
    AddType text/x-js .js4
    AddType video/asf .asf .asx .wax .wmv .wmx
    AddType video/avi .avi
    AddType image/avif .avif
    AddType image/avif-sequence .avifs
    AddType image/bmp .bmp
    AddType application/java .class
    AddType video/divx .divx
    AddType application/msword .doc .docx
    AddType application/vnd.ms-fontobject .eot
    AddType application/x-msdownload .exe
    AddType image/gif .gif
    AddType application/x-gzip .gz .gzip
    AddType image/x-icon .ico
    AddType image/jpeg .jpg .jpeg .jpe
    AddType image/webp .webp
    AddType application/json .json
    AddType application/vnd.ms-access .mdb
    AddType audio/midi .mid .midi
    AddType video/quicktime .mov .qt
    AddType audio/mpeg .mp3 .m4a
    AddType video/mp4 .mp4 .m4v
    AddType video/mpeg .mpeg .mpg .mpe
    AddType video/webm .webm
    AddType application/vnd.ms-project .mpp
    AddType application/x-font-otf .otf
    AddType application/vnd.ms-opentype ._otf
    AddType application/vnd.oasis.opendocument.database .odb
    AddType application/vnd.oasis.opendocument.chart .odc
    AddType application/vnd.oasis.opendocument.formula .odf
    AddType application/vnd.oasis.opendocument.graphics .odg
    AddType application/vnd.oasis.opendocument.presentation .odp
    AddType application/vnd.oasis.opendocument.spreadsheet .ods
    AddType application/vnd.oasis.opendocument.text .odt
    AddType audio/ogg .ogg
    AddType video/ogg .ogv
    AddType application/pdf .pdf
    AddType image/png .png
    AddType application/vnd.ms-powerpoint .pot .pps .ppt .pptx
    AddType audio/x-realaudio .ra .ram
    AddType image/svg+xml .svg .svgz
    AddType application/x-shockwave-flash .swf
    AddType application/x-tar .tar
    AddType image/tiff .tif .tiff
    AddType application/x-font-ttf .ttf .ttc
    AddType application/vnd.ms-opentype ._ttf
    AddType audio/wav .wav
    AddType audio/wma .wma
    AddType application/vnd.ms-write .wri
    AddType application/font-woff .woff
    AddType application/font-woff2 .woff2
    AddType application/vnd.ms-excel .xla .xls .xlsx .xlt .xlw
    AddType application/zip .zip
</IfModule>
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css A31536000
    ExpiresByType text/x-component A31536000
    ExpiresByType application/x-javascript A31536000
    ExpiresByType application/javascript A31536000
    ExpiresByType text/javascript A31536000
    ExpiresByType text/x-js A31536000
    ExpiresByType video/asf A31536000
    ExpiresByType video/avi A31536000
    ExpiresByType image/avif A31536000
    ExpiresByType image/avif-sequence A31536000
    ExpiresByType image/bmp A31536000
    ExpiresByType application/java A31536000
    ExpiresByType video/divx A31536000
    ExpiresByType application/msword A31536000
    ExpiresByType application/vnd.ms-fontobject A31536000
    ExpiresByType application/x-msdownload A31536000
    ExpiresByType image/gif A31536000
    ExpiresByType application/x-gzip A31536000
    ExpiresByType image/x-icon A31536000
    ExpiresByType image/jpeg A31536000
    ExpiresByType image/webp A31536000
    ExpiresByType application/json A31536000
    ExpiresByType application/vnd.ms-access A31536000
    ExpiresByType audio/midi A31536000
    ExpiresByType video/quicktime A31536000
    ExpiresByType audio/mpeg A31536000
    ExpiresByType video/mp4 A31536000
    ExpiresByType video/mpeg A31536000
    ExpiresByType video/webm A31536000
    ExpiresByType application/vnd.ms-project A31536000
    ExpiresByType application/x-font-otf A31536000
    ExpiresByType application/vnd.ms-opentype A31536000
    ExpiresByType application/vnd.oasis.opendocument.database A31536000
    ExpiresByType application/vnd.oasis.opendocument.chart A31536000
    ExpiresByType application/vnd.oasis.opendocument.formula A31536000
    ExpiresByType application/vnd.oasis.opendocument.graphics A31536000
    ExpiresByType application/vnd.oasis.opendocument.presentation A31536000
    ExpiresByType application/vnd.oasis.opendocument.spreadsheet A31536000
    ExpiresByType application/vnd.oasis.opendocument.text A31536000
    ExpiresByType audio/ogg A31536000
    ExpiresByType video/ogg A31536000
    ExpiresByType application/pdf A31536000
    ExpiresByType image/png A31536000
    ExpiresByType application/vnd.ms-powerpoint A31536000
    ExpiresByType audio/x-realaudio A31536000
    ExpiresByType image/svg+xml A31536000
    ExpiresByType application/x-shockwave-flash A31536000
    ExpiresByType application/x-tar A31536000
    ExpiresByType image/tiff A31536000
    ExpiresByType application/x-font-ttf A31536000
    ExpiresByType application/vnd.ms-opentype A31536000
    ExpiresByType audio/wav A31536000
    ExpiresByType audio/wma A31536000
    ExpiresByType application/vnd.ms-write A31536000
    ExpiresByType application/font-woff A31536000
    ExpiresByType application/font-woff2 A31536000
    ExpiresByType application/vnd.ms-excel A31536000
    ExpiresByType application/zip A31536000
</IfModule>
<IfModule mod_deflate.c>
    <IfModule mod_filter.c>
        AddOutputFilterByType DEFLATE text/css text/x-component application/x-javascript application/javascript text/javascript text/x-js text/html text/richtext text/plain text/xsd text/xsl text/xml image/bmp application/java application/msword application/vnd.ms-fontobject application/x-msdownload image/x-icon application/json application/vnd.ms-access video/webm application/vnd.ms-project application/x-font-otf application/vnd.ms-opentype application/vnd.oasis.opendocument.database application/vnd.oasis.opendocument.chart application/vnd.oasis.opendocument.formula application/vnd.oasis.opendocument.graphics application/vnd.oasis.opendocument.presentation application/vnd.oasis.opendocument.spreadsheet application/vnd.oasis.opendocument.text audio/ogg application/pdf application/vnd.ms-powerpoint image/svg+xml application/x-shockwave-flash image/tiff application/x-font-ttf application/vnd.ms-opentype audio/wav application/vnd.ms-write application/font-woff application/font-woff2 application/vnd.ms-excel
    <IfModule mod_mime.c>
        # DEFLATE by extension
        AddOutputFilter DEFLATE js css htm html xml
    </IfModule>
    </IfModule>
</IfModule>
<FilesMatch \"\.(css|htc|less|js|js2|js3|js4|CSS|HTC|LESS|JS|JS2|JS3|JS4)$\">
    FileETag MTime Size
    <IfModule mod_headers.c>
        Header unset Set-Cookie
    </IfModule>
</FilesMatch>
<FilesMatch \"\.(html|htm|rtf|rtx|txt|xsd|xsl|xml|HTML|HTM|RTF|RTX|TXT|XSD|XSL|XML)$\">
    FileETag MTime Size
</FilesMatch>
<FilesMatch \"\.(asf|asx|wax|wmv|wmx|avi|avif|avifs|bmp|class|divx|doc|docx|eot|exe|gif|gz|gzip|ico|jpg|jpeg|jpe|webp|json|mdb|mid|midi|mov|qt|mp3|m4a|mp4|m4v|mpeg|mpg|mpe|webm|mpp|otf|_otf|odb|odc|odf|odg|odp|ods|odt|ogg|ogv|pdf|png|pot|pps|ppt|pptx|ra|ram|svg|svgz|swf|tar|tif|tiff|ttf|ttc|_ttf|wav|wma|wri|woff|woff2|xla|xls|xlsx|xlt|xlw|zip|ASF|ASX|WAX|WMV|WMX|AVI|AVIF|AVIFS|BMP|CLASS|DIVX|DOC|DOCX|EOT|EXE|GIF|GZ|GZIP|ICO|JPG|JPEG|JPE|WEBP|JSON|MDB|MID|MIDI|MOV|QT|MP3|M4A|MP4|M4V|MPEG|MPG|MPE|WEBM|MPP|OTF|_OTF|ODB|ODC|ODF|ODG|ODP|ODS|ODT|OGG|OGV|PDF|PNG|POT|PPS|PPT|PPTX|RA|RAM|SVG|SVGZ|SWF|TAR|TIF|TIFF|TTF|TTC|_TTF|WAV|WMA|WRI|WOFF|WOFF2|XLA|XLS|XLSX|XLT|XLW|ZIP)$\">
    FileETag MTime Size
    <IfModule mod_headers.c>
        Header unset Set-Cookie
    </IfModule>
</FilesMatch>
<IfModule mod_headers.c>
    Header set Referrer-Policy \"no-referrer-when-downgrade\"
</IfModule>
# END W3TC Browser Cache" > /var/www/html/.htaccess
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

# wp-cli plugins
cd /var/www/html
wp plugin activate akismet
wp plugin update akismet
wp plugin activate hello
wp theme delete twentytwenty
wp theme delete twentytwentyone
wp plugin install google-site-kit
wp plugin activate google-site-kit
wp plugin install w3-total-cache
wp plugin activate w3-total-cache
# enable page cache
cp /var/www/html/wp-content/plugins/w3-total-cache/wp-content/advanced-cache.php /var/www/html/wp-content/advanced-cache.php
mkdir /var/www/html/wp-content/cache
chmod 777 /var/www/html/wp-content/cache
mkdir /var/www/html/wp-content/w3tc-config
chmod 777 /var/www/html/wp-content/w3tc-config
service httpd restart
