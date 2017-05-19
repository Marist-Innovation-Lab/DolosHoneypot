#!/bin/bash

# Check that user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

#Install sudo for the new user
echo -e "\nInstalling sudo..."
apt-get install -q -y sudo

# Create a sudoer to then login as so psql can install correctly (psql does not like the root user setting up)
# If the account needs to be created we need to run the rest of the script as that user, thus we create a new script to be run as that user.
echo "You cannot be logged in as root (your prompt is #) Please confirm you are running this script as a sudoer (your prompt is $) and not root y/n"
read -r -n 1 USERFLAG
echo
if [[ "$USERFLAG" == [Nn]* ]]
 then
  echo -e "\nPlease fill out the information below to create a new sudoer"
  read -p "Username : " USERNAME
  useradd -m $USERNAME
  passwd $USERNAME
  adduser $USERNAME sudo
 
  cat > install-minibian-pt2.sh << "EOF"
 #!/bin/bash
 
 #Check that user is root
 if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
 fi

##Collect data for configuring rsyslog 
echo -e "Please enter the ip that syslog should send logs to [Format: 0.0.0.0:Port]: "
read SYSLOG_SERVER
if [[ $SYSLOG_SERVER ]]
 then
  echo -e "Which protocol would you like to use for the syslog? TCP or UDP: "
  read PROTOCOL 

  while true
   do
    if [ "$PROTOCOL" != "TCP" ] && [ "$PROTOCOL" != "UDP" ]
     then
     echo -e "Please enter a valid protocol. TCP or UDP: "
     read PROTOCOL
    elif [ "$PROTOCOL" == "TCP" ] || [ "$PROTOCOL" == "UDP" ]
     then
     break 2
    fi
   done
fi

 # Install required packages
 echo -e "\nInstalling required packages..."

  apt-get update

 for i in apache2 php5 postgresql php5-pgsql libapache2-mod-php5 libapache2-modsecurity ; do
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
 
 # Configure rsyslog
echo -e "\nConfiguring rsyslog..."

if [[ $SYSLOG_SERVER ]]
 then
  if [[ "$PROTOCOL" == "TCP" ]]
   then
    sed -i '/#$ModLoad imtcp/ c\$ModLoad imtcp' /etc/rsyslog.conf
    sed -i '/#$InputTCPServerRun .*/ c\$InputTCPServerRun 514' /etc/rsyslog.conf
  elif [[ "$PROTOCOL" == "UDP" ]]
   then
    sed -i '/#$ModLoad imudp/ c\$ModLoad imudp' /etc/rsyslog.conf
    sed -i '/#$InputUDPServerRun .*/ c\$InputUDPServerRun 514' /etc/rsyslog.conf
  fi
 echo "*.* @@${SYSLOG_SERVER};RSYSLOG_SyslogProtocol23Format" > /etc/rsyslog.d/00-DOLOS.conf
fi

#Check for / Generate uuid for the HoneyPotID (HPID)

echo -e "Checking if you have an HPID..."
CHECK_ID_ENVIROMENT=$(grep -oP "HPID=.*" /etc/environment | sed 's/HPID=//g')
if [[ -z $CHECK_ID_ENVIROMENT ]]
 then 
  echo -e "Generating your unique HPID..."
  export HPID=$(dbus-uuidgen)
  echo "HPID=${HPID}" >> /etc/environment
  echo "HPID=${HPID}" >> /etc/apache2/envvars
fi
CHECK_ID_APACHE=$(grep -oP "HPID=.*" /etc/apache2/envvars | sed 's/HPID=//g')
if [[ -z $CHECK_ID_APACHE ]]
 then
  echo -e "Generating your unique HPID..."
  echo "# Environment variable for HPID loaded into Apache" >> /etc/apache2/envvars
  echo "export HPID=$CHECK_ID_ENVIROMENT" >> /etc/apache2/envvars
else
 echo -e "You already have an HPID... skipping step..."
fi

 # Restart Apache and Postgres so the configurations get enabled
 service apache2 restart
 service postgresql restart

 echo -e "\nDolos honeypot install complete. You can access the database through the command 'sudo psql -d doloshp'"
 echo -e "To view the web interface: {serverIP}:8080/index.html"  
EOF
  chmod +x install-minibian-pt2.sh
  sudo -u $USERNAME sudo ./install-minibian-pt2.sh
  exit
fi

#Collect data for configuring rsyslog 
echo -e "Please enter the ip that syslog should send logs to [Format: 0.0.0.0:Port]: "
read SYSLOG_SERVER
if [[ $SYSLOG_SERVER ]]
 then
  echo -e "Which protocol would you like to use for the syslog? TCP or UDP: "
  read PROTOCOL 

  while true
   do
    if [ "$PROTOCOL" != "TCP" ] && [ "$PROTOCOL" != "UDP" ]
     then
     echo -e "Please enter a valid protocol. TCP or UDP: "
     read PROTOCOL
    elif [ "$PROTOCOL" == "TCP" ] || [ "$PROTOCOL" == "UDP" ]
     then
     break 2
    fi
   done
fi

# Install required packages
echo -e "\nInstalling required packages..."

apt-get update

for i in apache2 php5 postgresql php5-pgsql libapache2-mod-php5 libapache2-modsecurity ; 
 do
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

# Configure rsyslog
echo -e "\nConfiguring rsyslog..."

if [[ $SYSLOG_SERVER ]]
 then
  if [[ "$PROTOCOL" == "TCP" ]]
   then
    sed -i '/#$ModLoad imtcp/ c\$ModLoad imtcp' /etc/rsyslog.conf
    sed -i '/#$InputTCPServerRun .*/ c\$InputTCPServerRun 514' /etc/rsyslog.conf
  elif [[ "$PROTOCOL" == "UDP" ]]
   then
    sed -i '/#$ModLoad imudp/ c\$ModLoad imudp' /etc/rsyslog.conf
    sed -i '/#$InputUDPServerRun .*/ c\$InputUDPServerRun 514' /etc/rsyslog.conf
  fi
 echo "*.* @@${SYSLOG_SERVER};RSYSLOG_SyslogProtocol23Format" > /etc/rsyslog.d/00-DOLOS.conf
fi

#Check for / Generate uuid for the HoneyPotID (HPID)

echo -e "Checking if you have an HPID..."
CHECK_ID_ENVIROMENT=$(grep -oP "HPID=.*" /etc/environment | sed 's/HPID=//g')
if [[ -z $CHECK_ID_ENVIROMENT ]]
 then 
  echo -e "Generating your unique HPID..."
  export HPID=$(dbus-uuidgen)
  echo "HPID=${HPID}" >> /etc/environment
  echo "HPID=${HPID}" >> /etc/apache2/envvars
fi
CHECK_ID_APACHE=$(grep -oP "HPID=.*" /etc/apache2/envvars | sed 's/HPID=//g')
if [[ -z $CHECK_ID_APACHE ]]
 then
  echo -e "Generating your unique HPID..."
  echo "# Environment variable for HPID loaded into Apache" >> /etc/apache2/envvars
  echo "export HPID=$CHECK_ID_ENVIROMENT" >> /etc/apache2/envvars
else
 echo -e "You already have an HPID... skipping step..."
fi



# Restart Apache, RSYSLOG, and Postgres so the configurations get enabled
service apache2 restart
service postgresql restart
service rsyslog restart

echo -e "\nDolos honeypot install complete. You can access the database through the command 'sudo psql -d doloshp'"
echo -e "To view the web interface: {serverIP}:8080/index.html"


# For the HPID to fully register within APACHE2 and ENVVARS the machine must be rebooted
echo -e "This machine must be rebooted for installation to finalize. Would you like to reboot now? y/n"
read -r -n 1 REBOOT
echo
if [[ "$REBOOT" == [Yy]* ]]
 then
 /sbin/shutdown -r +1 DOLOS Configuration
fi



exit