#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# create persistent shared storage
docker volume create backpack
docker volume inspect backpack

# start mongo container and validate in docker
docker pull mongo:4.0.4
docker run -d --rm --name legdrop mongo:4.0.4
docker ps -a

# validate mongo service availability
sleep 1
mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
until [[ $mongoHealth =~ "Implicit" ]]; do
	sleep 1
	mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
done

# start kali VM and validate in docker
docker image build -t drawer ./kali
docker inspect drawer
docker run -t -d --rm --mount source=backpack,target=/usr/local/cloudWraith --name scalpel drawer
docker ps -a

# validate metasploit health
metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
# metasploitHealth="$(docker exec scalpel msfupdate)"