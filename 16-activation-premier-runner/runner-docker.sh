
echo "INSTALL DOCKER"

curl -fsSL https://get.docker.com -o get-docker.sh 2>&1 
sudo sh get-docker.sh 2>&1 >/dev/null
sudo usermod -aG docker vagrant
sudo service docker start

echo "END INSTALL DOCKER"


mkdir -p /data/
sudo docker run -d  \
   --name gitlab-runner \
   --restart always \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -v /data/gitlab-runner:/etc/gitlab-runner \
   gitlab/gitlab-runner:latest