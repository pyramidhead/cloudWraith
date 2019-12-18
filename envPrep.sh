#!/bin/bash
# dev environment preparer to work with cloudWraith

# install linux dependencies
sudo apt-get update
sudo apt-get -f install apt-transport-https
sudo apt-get -f install ca-certificates
sudo apt-get -f install curl

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -f install docker-ce
sudo apt-get -f install docker-ce-cli
sudo apt-get -f install containerd.io
echo Initial health check:
sudo docker run hello-world

# prepare for code deployment
sudo chmod 755 ~/cloudWraith/pull.sh