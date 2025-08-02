# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

Objectifs :

		* améliorations

		* scan sécurité des images via trivy

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* version

```
    - MVN_VERSION=$(mvn --non-recursive help:evaluate -Dexpression=project.version | grep -v '\[.*')

ajout `| perl -nle 'm{(.* )?([0-9]+\.[0-9]+\.[0-9]+)};print $2'`

```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* skip tests au build

```
    - 'mvn ${MAVEN_OPTS} -Drevision=x.y.z-SUFFIX -DskipTests -B clean install'
```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* utilisation des needs
* needs crée une dépendance et embarque les artifacts de test et Build_Jar dans le jobe Build_docker
```
Build_docker:
  needs:
    - Test
    - Build_Jar
```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* amélioration du build docker (--cache-from > latest)

```
  script:
      - source ${VARIABLES_FILE}
      - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
      - docker build --cache-from $CI_REGISTRY_IMAGE/myapp:latest
        -t $CI_REGISTRY_IMAGE/myapp:v${MVN_VERSION}
        -t $CI_REGISTRY_IMAGE/myapp:latest .
      - docker push   $CI_REGISTRY_IMAGE/myapp:v${MVN_VERSION}
```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* scan - 1. dépendances - déclaration de stage

* trivy permet de scanner les images qui se trouvent dans la registry docker de gitlab pour la sécurité

```
Scan:
  stage: scan
  needs:
    - Test
    - Build_Jar
    - Build_docker
```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* scan - 2. conf de l'environnement 

* les variables pour la connection de trivy à la registry gitlab

```
  image:
    name: aquasec/trivy
    entrypoint: [""]
  variables:
    TRIVY_AUTH_URL: $CI_REGISTRY
    TRIVY_USERNAME: $CI_REGISTRY_USER
    TRIVY_PASSWORD: $CI_REGISTRY_PASSWORD
```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* scan - 3. commande et arguments (attention exit 0)

* ici on va scanner des images avec la commande trivy avec le répertoire .cache

* la derniere ligne correspond à l'image qu 'on veut scanner

```
  script:
    - source ${VARIABLES_FILE}
    - trivy --cache-dir .cache image
      --exit-code 0
      --severity HIGH,CRITICAL
      --format table --output report.md
      --vuln-type os
      $CI_REGISTRY_IMAGE/myapp:v${MVN_VERSION}
```

----------------------------------------------------------------------------------------------------

# GITLAB : 33	- CI : MultiProject Pipeline - Scan, needs et arti

<br>

* scan - 4. stockage du rapport de scan (éventuellement conditionné)

```
  artifacts:
      name: "Scan Report ${CI_COMMIT_SHA}"
      paths:
        - report.md
      expire_in: 7 days
      when: on_failure
  cache:
    paths:
      - ".cache"
  tags:
    - docker
```
