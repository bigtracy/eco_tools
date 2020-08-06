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
    ecodms_sources="\"deb http://www.ecodms.de/ecodms_180964/buster /\""
    ;;
   "9" )	
    ecodms_sources="\"deb http://www.ecodms.de/ecodms_180964/stretch /\""
    ;;
  esac
    ;;
	"ubuntu" )
	ecodms_sources="\"deb http://www.ecodms.de/ecodms_180964/bionic /\""
    ;;

	* )
	echo "#################################################################"
	echo "No suitable OS and/or Version for installation found. STOPPED!!!"
	echo "#################################################################"
	exit 8
	;;
 esac

echo "#################################################################"
echo "Found $OS $VERSION. Good."
echo "#################################################################"

# Read username to check for use of sudo
username=$(whoami)
prefix = ""
if [[ $username != "root" ]] 
then
		prefix="sudo "
		echo "###################################################"
		echo "Not root, so run with sudo"
		echo "###################################################"
fi

# needed configs for succesfull installation
$prefix apt update
$prefix export LANG=de_DE.UTF8
$prefix dpkg-reconfigure locales
$prefix dpkg-reconfigure tzdata

$prefix apt upgrade -y
$prefix apt install sudo gnupg2 -y

# prepare ecodms installation
$prefix wget -O - http://www.ecodms.de/gpg/ecodms.key | sudo apt-key add -
$prefix echo $ecodms_sources > /etc/apt/sources.list.d/ecodms.list
$prefix apt update

# install ecodmsserver
$prefix apt install ecodmsserver -y
