# GITLAB : 31 - CI : MultiProject Pipeline - Ansible

* On va installer une base de données postgres dans un serveur target distant

* pour se faire, nous allons créer un utilisateur que ansible va utiliser pour se connecter via ssh key

* on va biensure generer un cle ssh de ecdsa ou rsa et on va récuperé la clé privé et la mettre dans une variable de projet sur l'instance gitlab

* notre target ici est le meme serveur dans lequel on est situé
<br>

sudo adduser gitlab
cat /etc/passwd
sudo usermod -aG sudo gitlab
sudo su - saliou
ssh-keygen -t ecdsa -b 521
cat .ssh/id_ecdsa
hostname -I
cat .ssh/id_ecdsa.pub
cat .ssh/id_ecdsa.pub > .ssh/authorized_keys


* On crée un nouveau projet dans l'instance GITLAB par exemple ansible_postgres

SSH_PRIVATE
SSH_USER
IP_SSH_TARGET
SUDO_USER_PWD
