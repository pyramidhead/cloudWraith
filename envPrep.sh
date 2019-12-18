#!/bin/bash
# dev environment preparer to work with cloudWraith

# install linux dependencies
sudo apt-get update
sudo apt-get -f install apt-transport-https
sudo apt-get -f install ca-certificates
sudo apt-get -f install curl
sudo apt-get -f install mongodb-clients

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -f install aufs-tools
sudo apt-get -f install cgroupfs-mount
sudo apt-get -f install libltdl7
sudo apt-get -f install pigz
sudo apt-get -f install docker-ce-cli
sudo apt-get -f install containerd.io
sudo apt-get -f install docker-ce
sudo docker run hello-world

# final linux side steps; group membership and file permissions
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 755 ~/cloudWraith/pull.sh