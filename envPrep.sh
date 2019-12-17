#!/bin/bash
# dev environment preparer to work with cloudWraith

# install linux dependencies
sudo apt-get update
sudo apt-get install -f \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	gnupg-agent

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -f docker-ce docker-ce-cli containerd.io
echo Initial health check:
sudo docker run hello-world
echo 

# validate docker from another shell
sudo usermod -aG docker $USER
chmod 755 ~/cloudWraith/docker/dockerCheck.sh
spineCheck="$(~/cloudWraith/docker/dockerCheck.sh)";
echo Shelled health check:
echo $spineCheck
echo 