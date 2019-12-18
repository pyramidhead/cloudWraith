#!/bin/bash
# dev environment preparer to work with cloudWraith

# install linux dependencies
sudo apt-get update
sudo apt-get -f install apt-transport-https
sudo apt-get -f install ca-certificates
sudo apt-get -f install curl

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo Adding docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
echo Running apt-get update
sudo apt-get update
echo Installing known dependencies
sudo apt-get -f install aufs-tools
sudo apt-get -f install cgroupfs-mount
sudo apt-get -f install libltdl7
sudo apt-get -f install pigz
echo Running docker package installs
sudo apt-get -f install docker-ce-cli
sudo apt-get -f install containerd.io
sudo apt-get -f install docker-ce
echo Initial health check:
sudo docker run hello-world

# prepare for code deployment
sudo chmod 755 ~/cloudWraith/pull.sh