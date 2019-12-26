#!/bin/bash
# master script to operate a containerized pentesting architecture utilizing various resources to identify vulnerabilities
# prerequisites: docker

# build persistent shared storage
docker volume create backpack
docker volume inspect backpack

# build and validate mongo container
docker pull mongo:4.0.4
docker run -d --rm --name legdrop mongo:4.0.4
docker ps -a
sleep 1
mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
until [[ $mongoHealth =~ "Implicit" ]]; do
	sleep 1
	mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
done

# build and validate kali container
docker image build -t drawer ./kali
docker inspect drawer
docker run -t -d --rm --mount source=backpack,target=/usr/local/cloudWraith --name scalpel drawer
docker ps -a
kaliHealth="$(docker exec scalpel cat /etc/os-release | grep "ID_LIKE")"
until [[ $kaliHealth =~ "ID_LIKE" ]]; do
	sleep 1
	kaliHealth="$(docker exec scalpel cat /etc/os-release | grep "ID_LIKE")"
done
# not sure why metasploit install doesn't work from the dockerfile; doing it from here
docker exec scalpel ./msfinstall
# validate metasploit availability
docker exec scalpel msfconsole
# validate container status
docker ps -a