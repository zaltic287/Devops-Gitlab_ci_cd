#!/bin/bash


IP=$(hostname -I | awk '{print $2}')

echo "START - install gitlab - "$IP

echo "[1]: install target-ssh"
#sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
#sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list
sudo apt-get update -qq >/dev/null
apt-get install -qq -y vim git wget curl git >/dev/null
echo "END - install target-ssh"



#sudo dpkg-reconfigure locales

