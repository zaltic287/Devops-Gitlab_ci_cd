#!/bin/bash


IP=$(hostname -I | awk '{print $2}')
GITLABURL=$1

echo "START - install runner shell - "$IP

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
apt --fix-broken install
sudo apt install gitlab-runner -y
sudo gitlab-runner status

echo "END - install runergitlab executor shell"

#curl -sL "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#chmod +x /usr/local/bin/docker-compose 
#usermod -aG docker gitlab-runner
#sed -i s/"gitlab"/"gitlab $1"/g /etc/hosts


#sudo dpkg-reconfigure locales
