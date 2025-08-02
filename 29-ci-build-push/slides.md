%title: GITLAB


# GITLAB : 29 - CI : build + push

<br>

Build d'une image 

		* utilisation de docker in docker

		* attention au certificat de la registry

---------------------------------------------------------------------------------------------

# GITLAB : 29 - CI : build + push

<br>

* ajout du certificat sur la vm du runner

```
openssl s_client -showcerts -connect registry.gitlab.example.com:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | sudo tee /usr/local/share/ca-certificates/registry.crt
sudo update-ca-certificates
```

<br>

* changement de la conf du runner en ajoutant un volume qui sera monté dans les conteneurs pour qu'il puisse avoir accés au certificat

* et se connecter à la registry

docker inspect gitlab-runner
vim /data/gitlab-runner/config.toml

```
volumes = ["/cache", "/usr/local/share/ca-certificates/registry.crt:/etc/ssl/certs/registry.crt:ro"]
```

* NB: ici on monte uniquement le certificat et non pas l'ensembles du repertoir des certificats du runner: /etc/ssl/certs/ sinon probleme avec ansible
```
docker restart gitlab-runner
```

---------------------------------------------------------------------------------------------

# GITLAB : 29 - CI : build + push

<br>

````
stages:
    - build
build image:
    stage: build
    image: docker
    services:
        - name: docker:dind
          alias: docker
    variables:
        DOCKER_BUILDKIT: "1"
        DOCKER_DRIVER: overlay2
        DOCKER_HOST: tcp://docker:2375
        DOCKER_TLS_CERTDIR: ""
    script:
        - docker build  -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
                        -t $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
                        .
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker push   $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
        - docker push   $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
    tags:
        - docker
```
