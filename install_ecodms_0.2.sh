#!/bin/bash

username=$(whoami)
prefix = ""
if [[ $username != "root" ]] 
then
		prefix="sudo "
		echo "###################################################"
		echo "Not root, so run with sudo"
		echo "###################################################"
fi

$prefix apt update
$prefix export LANG=de_DE.UTF8
$prefix dpkg-reconfigure locales
$prefix dpkg-reconfigure tzdata

$prefix apt upgrade -y
$prefix apt install sudo gnupg2 -y
$prefix wget -O - http://www.ecodms.de/gpg/ecodms.key | sudo apt-key add -
$prefix echo "deb http://www.ecodms.de/ecodms_180964/buster /" > /etc/apt/sources.list.d/ecodms.list

$prefix apt update

$prefix apt install ecodmsserver -y
