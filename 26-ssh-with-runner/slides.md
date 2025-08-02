# GITLAB : 26 - SSH runner vers target


<br>

Pré-requis :

		* créer une paire de clefs sur la target

		* créer un user (avec les droits souhaités)

		* ajouter la clef publique sur le serveur cible


----------------------------------------------------------------------------

# GITLAB : 26 - SSH runner vers target

<br>

* création du user sur la target1

```
ssh-keygen -t ecdsa -b 521
le nom de la clef: saliou
sudo adduser saliou
new password:vagrant
mkdir - /home/saliou/.ssh
cat saliou.pub | sudo tee /home/saliou/.ssh/authorized_keys
sudo chown -R saliou:saliou /home/saliou/.ssh
sudo usermod -aG sudo saliou
id saliou
```

* création du user sur la target2

```
ssh-keygen -t ecdsa -b 521  || On peut utiliser la meme clé généré précedemment ou en creer un autr
le nom de la clef: saliou
sudo adduser saliou
new password:vagrant
sudo mkdir - /home/saliou/.ssh
cat saliou.pub | sudo tee /home/saliou/.ssh/authorized_keys
sudo chown -R saliou:saliou /home/saliou/.ssh
sudo usermod -aG sudo saliou
id saliou

----------------------------------------------------------------------------

# GITLAB : 26 - SSH runner vers target

<br>

PIPELINE

* création des variables dans l'instance GITLAB: settings > CI/CD > variables

```
SSH_PRIVATE		# variable qui stock la clef prive du serveur cible
SSH_TARGET		# adresse Ip du serveur target (hostname -I)
SSH_USER		# nom de l'utilisateur sur la machine cible en loccurence saliou
SUDO_USER_PWD	# variable qui stock le mot de passe pour l'elevation de privilege en loccurence vagrant
```

----------------------------------------------------------------------------

# GITLAB : 26 - SSH runner vers target

<br>

* configuration de SSH dans notre runner (docker ou non)

```
image: debian:latest
job1:
  before_script:
    - 'command -v ssh-agent >/dev/null || ( apt update && apt install -y openssh-client )' 
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_TARGET >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
	- apt-get install -y ansible
```

----------------------------------------------------------------------------

# GITLAB : 26 - SSH runner vers target

<br>

* test de ssh

```
  script:
  - ssh $SSH_USER@$SSH_TARGET "hostname"
  tags:
    - docker
```

----------------------------------------------------------------------------

# GITLAB : 26 - SSH runner vers target

<br>

* et ansible ???

```
  script:
  - ansible -i "$SSH_TARGET," all -u $SSH_USER -m command -a uptime
```

----------------------------------------------------------------------------

# GITLAB : 26 - SSH runner vers target

<br>

* adaptation

```
...
        - echo "[all]" > inventory.ini
        - echo "$SSH_TARGET" >> inventory.ini
        - ANSIBLE_BECOME_PASS=$SUDO_USER_PWD ansible-playbook -i inventory.ini -l $SSH_TARGET -u $SSH_USER playbook.yml
```

```

* création d'un fichier playbook dans l'instance GITLAB || exemple playbook.yaml
-   name: my playbook
    hosts: all
    become: yes
    tasks:
    - name: t1
      apt: 
        name: nginx
        state: latest
```

