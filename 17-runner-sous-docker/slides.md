# GITLAB : 17 - lancer un runner sous docker


<br>

Gitlab > settings > CI/CD > Runners

Specific/Shared runners

Doc : https://docs.gitlab.com/runner/install/index.html
Linux : https://docs.gitlab.com/runner/install/linux-manually.html

Note : dns vers l'instance gitlab

````
echo "INSTALL DOCKER"

curl -fsSL https://get.docker.com -o get-docker.sh 2>&1 
sudo sh get-docker.sh 2>&1 >/dev/null
sudo usermod -aG docker vagrant
sudo service docker start

echo "END INSTALL DOCKER"
   
````

```
mkdir -p /data/
sudo docker run -d  \
   --name gitlab-runner \
   --restart always \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -v /data/gitlab-runner:/etc/gitlab-runner \
   gitlab/gitlab-runner:latest
```

-----------------------------------------------------------------------------------------

# GITLAB : 17 - lancer un runner sous docker

````
	
````

-----------------------------------------------------------------------------------------

# GITLAB : 17 - lancer un runner sous docker
Test:
  stage: test	
  image: debian:latest
  script:
    - echo "Start..."
    - sleep 60
    - echo "ended !!"

echo "registry.gitlab.example.com 192.168.7.10" > /etc/resolv.conf