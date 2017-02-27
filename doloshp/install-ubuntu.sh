#!/bin/bash

# Check that user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

# Install required packages
echo -e "\nInstalling required packages..."

for i in apache2 php postgresql php-pgsql libapache2-mod-php libapache2-modsecurity ; do
  echo -en "\n>Installing $i...\n"
  apt-get install -q -y $i
done

# Activate required Apache2 modules
echo -e "\nActivating required modules..."

a2enmod rewrite
a2enmod headers
a2enmod userdir

# Copy files to HTML directory
echo -e "\nCopying files..."

HTML_DIR="/var/www/html"

cp -rf doloshoneypot/html_config/. $HTML_DIR
ln -s $HTML_DIR/src/checkUser.php $HTML_DIR/restconf/modules

# Copy files Apache config files to Apache directory
APACHE_DIR="/etc/apache2"

mv $APACHE_DIR/ports.conf $APACHE_DIR/ports.conf.old
mv $APACHE_DIR/sites-available/000-default.conf $APACHE_DIR/sites-available/000-default.conf.old
mv $APACHE_DIR/conf-available/security.conf $APACHE_DIR/conf-available/security.conf.old
rm $APACHE_DIR/sites-enabled/000-default.conf
rm $APACHE_DIR/conf-enabled/security.conf

cp -f doloshoneypot/apache_config/ports.conf $APACHE_DIR
cp -f doloshoneypot/apache_config/000-default.conf $APACHE_DIR/sites-available
cp -f doloshoneypot/apache_config/security.conf $APACHE_DIR/conf-available

ln -s $APACHE_DIR/sites-available/000-default.conf $APACHE_DIR/sites-enabled/000-default.conf
ln -s $APACHE_DIR/conf-available/security.conf $APACHE_DIR/conf-enabled/security.conf

# Copy Postgres config files
PG_DIR="/etc/postgresql/$(ls /etc/postgresql)/main"

mv $PG_DIR/pg_hba.conf $PG_DIR/pg_hba.conf.old
cp -f doloshoneypot/pg_hba.conf $PG_DIR/pg_hba.conf

# Setting up the database
echo -e "\nSetting up the database..."
sudo -i -u postgres createuser -s $USER
createdb -O $USER doloshp
psql doloshp -f doloshoneypot/dolosSQL.sql

# Uncomment line in php.ini file to disable caching in connect.php
ini_file_loc=`find /etc -print0 | grep -FzZ "apache2/php.ini"`
sed -i '/opcache.enable=0/s/^;//g' $ini_file_loc

# Restart Apache and Postgres so the configurations get enabled
service apache2 restart
service postgresql restart

echo -e "\nDolos honeypot install complete. You can access the database through the command 'sudo psql -d doloshp'"
echo -e "To view the web interface: {serverIP}:8080/index.html"



