#!/bin/bash

# Check that user is root
if [ "$EUID" -ne 0 ]
 then echo "Please run this script as root"
 exit
fi

# stop running services that will interfere

service postgresql stop
service apache2 stop
service php5 stop

apt-get -q -y --purge remove postgresql\*
apt-get -q -y --purge remove apache2\*
apt-get -q -y --purge remove php5

rm /etc/rsyslog.d/00-DOLOS.conf