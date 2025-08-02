# GITLAB : 06 - Premier Git Clone


<br>

git clone (ssh|https)

3 types d'accès :

		* ssh

		* https : variables d'environnement
				http://${GIT_USER}:${GIT_PASSWORD}@gitlaburl

		* token (Personnal/Project)
				https://<token-name>:<token>@gitlaburl


<br>

```
vim .environnement

export GIT_USER=saliou
export GIT_PASSWORD=zale1998

source .environnement

ssh-keygen -t rsa

cat ~/.ssh/id-rsa.pub

copier la clé publique dans l'hote distant

```
