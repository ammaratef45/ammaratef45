data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = [ "amazon" ]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/refresh/"
  output_path = "${path.module}/refresh/refresh.zip"
}

data "template_file" "user_data" {
  template = <<-EOL
  #!/bin/bash -xe
  amazon-linux-extras enable php8.2
  yum update -y
  yum upgrade -y
  yum install -y ruby httpd php php-mysqlnd mariadb mariadb-devel mariadb-libs
  yum install -y mod_ssl php-dom php-imagick php-mbstring php-intl
  wget http://wordpress.org/latest.tar.gz
  tar -xf latest.tar.gz
  mv wordpress/* /var/www/html
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  # DB
  DBName=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id BlogDBName --query 'SecretString' --output text)
  DBUser=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id BlogDBUser --query 'SecretString' --output text)
  DBPassword=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id BlogDBPassword --query 'SecretString' --output text)
  DBEndpoint=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id BlogDBEndpoint --query 'SecretString' --output text)
  sed -i "s/'database_name_here'/'$DBName'/g" /var/www/html/wp-config.php
  sed -i "s/'username_here'/'$DBUser'/g" /var/www/html/wp-config.php
  sed -i "s/'password_here'/'$DBPassword'/g" /var/www/html/wp-config.php
  sed -i "s/'localhost'/'$DBEndpoint'/g" /var/www/html/wp-config.php
  ## add s3 creds to config file
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
  # Akismet
  AkismetKey=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id AkismetKey --query 'SecretString' --output text)
  sed -i "/^.*WP_DEBUG.*/a define('WPCOM_API_KEY','$AkismetKey');" /var/www/html/wp-config.php
  # Cache
  sed -i "/^.*WP_DEBUG.*/a define('WP_CACHE',true);" /var/www/html/wp-config.php
  sed -i "/^.*WP_DEBUG.*/a define('WPCACHEHOME','/var/www/html/wp-content/plugins/wp-super-cache/');" /var/www/html/wp-config.php
  aws s3 cp s3://wordpressblog-setup/advanced-cache.php /var/www/html/wp-content/
  aws s3 cp s3://wordpressblog-setup/wp-cache-config.php /var/www/html/wp-content/
  mkdir /var/www/html/wp-content/uploads
  mkdir /var/www/html/wp-content/cache
  chown -R apache:apache /var/www/html
  # Apache
  sed -i "/^.*WP_USE_THEMES.*/a ob_start(\"ob_gzhandler\");" /var/www/html/index.php
  echo "LoadModule deflate_module modules/mod_deflate.so" >> /etc/httpd/conf/httpd.conf
  sed -i "s/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks/g" /etc/httpd/conf/httpd.conf
  sed -i "s/AllowOverride None/AllowOverride FileInfo/g" /etc/httpd/conf/httpd.conf
  touch /var/www/html/.htaccess
  yes | rm /var/www/html/.htaccess
  aws s3 cp s3://wordpressblog-setup/.htaccess /var/www/html/
  # Setup TLS
  aws secretsmanager get-secret-value --region us-east-1 --secret-id cdn-private-key --query 'SecretString' --output text | base64 -d > /etc/pki/tls/private/cdn.ammaratef45.key
  aws secretsmanager get-secret-value --region us-east-1 --secret-id cdn-public-crt --query 'SecretString' --output text | base64 -d > /etc/pki/tls/certs/cdn.ammaratef45.crt
  aws secretsmanager get-secret-value --region us-east-1 --secret-id cdn-chain --query 'SecretString' --output text | base64 -d > /etc/pki/tls/certs/cdn.ammaratef45.ca-bundle
  yes | rm /etc/httpd/conf.d/ssl.conf
  aws s3 cp s3://wordpressblog-setup/ssl.conf /etc/httpd/conf.d/
  # health-check
  echo "Instance is healthy" > /var/www/html/health.html
  # Loader.io verify ownership
  IO=loaderio-f852153bc07b866f211a343ba53a26e2
  echo "$IO" > /var/www/html/$IO.html
  # Adsense
  echo "google.com, pub-5308838739950508, DIRECT, f08c47fec0942fa0" > /var/www/html/ads.txt
  service httpd restart
  EOL
}