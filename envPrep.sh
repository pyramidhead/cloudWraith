#!/bin/bash
# dev environment preparer to work with cloudWraith

# install linux dependencies
sudo apt-get update
sudo apt-get install apt-transport-https -f
sudo apt-get install ca-certificates -f
sudo apt-get install curl -f
sudo apt-get install gnupg-agent -f

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce -f
sudo apt-get install docker-ce-cli -f
sudo apt-get install containerd.io -f
echo Initial health check:
sudo docker run hello-world

# prepare for code deployment
sudo chmod 755 ~/cloudWraith/pull.sh