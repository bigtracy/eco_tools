#!/bin/bash

# check OS
. /etc/os-release
ID=$ID
VERSION=$VERSION_ID


# Setting Repo for ecodms
ecodms_sources=""
case "$ID" in
   "debian" )
		case $VERSION in
			"10" )	
				ecodms_sources="deb http://www.ecodms.de/ecodms_180964/buster /"
				;;
			"9" )	
				ecodms_sources="deb http://www.ecodms.de/ecodms_180964/stretch /"
				;;
		esac
		;;
	"ubuntu" )
		ecodms_sources="deb http://www.ecodms.de/ecodms_180964/bionic /"
 	   ;;

	* )
		echo "#################################################################"
		echo "No suitable OS and/or Version for installation found. STOPPED!!!"
    	echo "Host System is $NAME $VERSION"
		echo "#################################################################"
		exit 8
		;;
esac

echo "#################################################################"
echo "Found $NAME $VERSION. Good."
echo "#################################################################"

# Read username to check for use of sudo
username=$(whoami)
prefix = ""
if [[ $username != "root" ]] 
then
		if ! dpkg-query -W -f='${Status}' sudo  | grep "ok installed"; 
			then 
				echo "###################################################"
				echo "Not root and sudo not installed. STOPPED!!!"
				echo "---------------------------------------------------"
				echo ""
				echo " Please install sudo "
				echo ""
				echo "###################################################"
			exit 8;
		fi

		prefix="sudo "
		echo "###################################################"
		echo "Not root, so run with sudo"
		echo "###################################################"
fi



# needed configs for succesfull installation
$prefix apt update
$prefix export LANG=de_DE.UTF8
sudo update-locale LANG=de_DE.UTF8
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
dpkg-reconfigure -f noninteractive tzdata


$prefix apt upgrade -y
$prefix apt install sudo gnupg2 -y

# prepare ecodms installation
$prefix wget -O - http://www.ecodms.de/gpg/ecodms.key | sudo apt-key add -
$prefix echo $ecodms_sources > /etc/apt/sources.list.d/ecodms.list
$prefix apt update

# install ecodmsserver
$prefix apt install ecodmsserver -y
