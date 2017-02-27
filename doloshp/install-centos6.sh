#!/bin/bash

# Check that user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

date=`date +%Y.%m.%d:%H:%M`

# Install required packages
echo -e "\nInstalling required packages..."

#for i in epel-release httpd php postgresql postgresql-server php-pgsql mod_security syslog-ng policycoreutils-python ; do
for i in epel-release httpd php postgresql postgresql-server php-pgsql mod_security policycoreutils-python ; do
  echo -en "\n>Installing $i...\n"
  yum -y install $i
done

chkconfig httpd on

echo -e "\nConfiguring ports...(This may take a little bit)"

# Allow ports for http access
echo -n "+"
semanage port -a -t http_port_t -p tcp 8181
echo -n "+"
semanage port -a -t http_port_t -p tcp 1099

echo -n "+"
lokkit --port=8080:tcp --update
echo -n "+"
lokkit --port=8181:tcp --update
echo -n "+"
lokkit --port=1099:tcp --update

echo "Enabling postgresql"
service postgresql initdb
service postgresql start
setsebool -P httpd_can_network_connect_db 1

# Copy files to HTML directory
echo -e "\nCopying files..."

HTML_DIR="/var/www/html"

cp -rf doloshoneypot/html_config/. $HTML_DIR
ln -s $HTML_DIR/src/checkUser.php $HTML_DIR/restconf/modules

# Copy files Apache httpd config files to httpd directory
HTTPD_DIR="/etc/httpd/conf"

mv $HTTPD_DIR/httpd.conf $HTTPD_DIR/httpd.conf.$date
cp -f doloshoneypot/httpd.conf $HTTPD_DIR

# Copy Postgres config files
PG_DIR="/var/lib/pgsql/data"

mv $PG_DIR/pg_hba.conf $PG_DIR/pg_hba.conf.$date
mv $PG_DIR/postgresql.conf $PG_DIR/postgresql.conf.$date
cp -f doloshoneypot/pg_hba.conf $PG_DIR/pg_hba.conf
cp -f doloshoneypot/postgresql.conf $PG_DIR/postgresql.conf

chown postgres:postgres $PG_DIR/pg_hba.conf $PG_DIR/postgresql.conf

# Setting up the database
echo -e "\nSetting up the database..."
sudo -i -u postgres createuser -s $USER
createdb -O $USER doloshp
psql doloshp -f doloshoneypot/dolosSQL.sql

# Change permissions to allow log messages to write to log file
chmod 777 /var/log

# Restart httpd so our configurations get enabled
service postgresql restart
service httpd restart

echo -e "\nDolos honeypot install complete. You can access the database through the command 'psql -d doloshp'"
echo -e "To view the web interface: {serverIP}:8080/index.html"


