#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# build persistent shared storage
docker volume create backpack
docker volume inspect backpack

# build mongo container
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

# build kali container
docker image build -t drawer ./kali
docker inspect drawer
docker run -t -d --rm --mount source=backpack,target=/usr/local/cloudWraith --name maglite drawer
docker ps -a
kaliHealth="$(docker attach maglite)"
echo $kaliHealth

# build remnux metasploit container
docker run -t -d --rm -p 443:443 --mount source=backpack,target=/usr/local/cloudWraith --name scalpel remnux/metasploit
docker ps -a
metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
echo $metasploitHealth
# metasploitHealth="$(docker exec scalpel msfupdate)"