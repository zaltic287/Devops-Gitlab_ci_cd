# GITLAB : 28 - La REGISTRY Docker

<br>

* problématique :

		* activer la registry

		* bénéficier d'une registry vérified via https

		* génération d'un certificat auto-signé

------------------------------------------------------------------------------

# GITLAB : 28 - La REGISTRY Docker


<br>

* configuration de gitlab
* edition du fichier /etc/gitlab/gitlab.rb

```
gitlab_rails['gitlab_default_projects_features_container_registry'] = true  # Tous les projets ont acces à la registry

registry_external_url 'https://registry.gitlab.example.com'

# Activation de la registry

gitlab_rails['registry_enabled'] = true
gitlab_rails['registry_host'] = "registry.gitlab.example.com"

#configuration de nginx

registry_nginx['enable'] = true
registry_nginx['listen_port'] = 443
registry_nginx['ssl_certificate'] = "/etc/gitlab/registry.gitlab.example.com.cert"
registry_nginx['ssl_certificate_key'] = "/etc/gitlab/registry.gitlab.example.com.key"
```

------------------------------------------------------------------------------

# GITLAB : 28 - La REGISTRY Docker


<br>

* génération du certificat auto-signé

```
sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.gitlab.example.com.key  -addext "subjectAltName = DNS:registry.gitlab.example.com" -x509 -days 365 -out registry.gitlab.example.com.cert
```

<br>

* reconfigure de gitlab

```
gitlab-ctl reconfigure
```

------------------------------------------------------------------------------

# GITLAB : 28 - La REGISTRY Docker


<br>

* gestion du cert auto-signé pour un client d'un autre vm

```
docker login registry.gitlab.example.com     # Il nous dit qu'il ne connait pas l'autorité de certification et donc il faut récupéré le certificat

openssl s_client -showcerts -connect registry.gitlab.example.com:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > registry.crt
cat registry.crt
sudo cp registry.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

NB: trés important  pour que le certificat puisse etre pris en compte par Docker

sudo systemctl daemon-reload
sudo systemctl restart docker
docker login registry.gitlab.example.com 

sudo docker tag alpine:latest registry.gitlab.example.com/mongroupe1/myregistry/alpine:v1.0

docker push registry.gitlab.example.com/mongroupe1/myregistry/alpine:v1.0

NB: les username/password est celui de l'instance gitlab
```
