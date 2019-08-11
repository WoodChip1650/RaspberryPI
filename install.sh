#########################################################################
#LAMP for Raspberry Pi                                                  #
#This script will install Apache, PHP, FTP, and MySQL, Webmin, myPHPAdmn#
#########################################################################

#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo "This Script must be run as root"
	exit 1
fi

#Prerequisites
echo "<-- Updating and Upgrading -->"
sudo apt-get update
sudo apt-get upgrade -y

#FTP
echo "<-- FTP -->"
sudo apt-get install -y proftpd

#Apache
echo "<-- apache2 -->"
sudo apt-get install -y apache2
sudo echo "ServerName RaspiServ" >> /etc/apache2/httpd.conf
wait 5
clear
#PHP
echo "<-- PHP -->"
sudo apt-get install -y php libapache2-mod-php php-fpm 
clear
#MySQL
echo "<-- Installing mySQL -->"
sudo apt-get install -y mysql-server mysql-client mysql_secure_installation
sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
wait 15
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'T@nkD@gD@g';
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
wait 15
exit
wait 5
clear
#Additional Dependencies
echo "<-- Installing Additional Dependencies -->"
sudo apt-get install -y nmap zenmap
wiat 5
#Webmin
echo "<-- Installing Deps and Webmin -->"
sudo mk /opt/install/Webmin/
sudo apt install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python -y
	sleep 20
	wget http://www.webmin.com/download/deb/webmin-current.deb  /opt/install/Webmin/webmin_all.deb
	dpkg -i /opt/install/Webmin/webmin_all.deb
	sleep 10
	rm -rf /opt/install/Webmin/webmin_all.deb	
	echo "Creating Startup Script"
	wget https://raw.githubusercontent.com/tazboyz16/Ubuntu-Server-Auto-Install/master/myapps/install/Webmin/webmin.service -O /etc/systemd/system/
	chmod 644 /etc/systemd/system/webmin.service
	update-rc.d webmin remove
	systemctl enable webmin.service
	systemctl restart webmin.service
	#Checking if Iptables is installed and updating with CP port settings
	    if [ -f /etc/default/iptables ]; then
	        sed -i "s/#-A INPUT -p tcp --dport 10000 -j ACCEPT/-A INPUT -p tcp --dport 10000 -j ACCEPT/g" /etc/default/iptables
	        /etc/init.d/iptables restart;
		fi
clear
systemctl status Webmin.service
wait 10
clear
#myPHPAdmin Fixer
curl -O -k https://raw.githubusercontent.com/skurudo/phpmyadmin-fixer/master/pma.sh && chmod +x pma.sh && ./pma.sh			
#myPHPAdmin
sudo apt install -y phpmyadmin
wait 10
rm-rf install.sh
exit
