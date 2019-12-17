#!/bin/bash
# dev environment preparer to work with cloudWraith

# install linux dependencies
sudo apt-get update
sudo apt-get install \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common \
	gnupg-agent \
	mysql-client-core-5.7 \
	mariadb-client-10.1

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
sudo groupadd docker
sudo usermod -aG docker $USER
# validate group membership
# docker run hello-world (we have to do this in a new shell so group membership applies)
spineCheck="$(~/docker/dockerCheck.sh)";
echo Shelled health check:
echo $spineCheck

# initial git pull

# add call to make pull.sh executable if possible