#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# create persistent shared storage
docker volume create backpack
docker volume inspect backpack

# start mongo container and validate in docker
docker pull mongo:4.0.4
docker run --rm --name legdrop -d mongo:4.0.4
docker ps -a

# validate mongo service availability
sleep 1
mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
until [[ $mongoHealth =~ "Implicit" ]]; do
	sleep 1
	mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
done

# start metasploit container in a kali VM and validate in docker
docker image build -t drawer ./kali
docker inspect drawer
docker run -it --rm --mount source=backpack,target=/usr/local/cloudWraith --name scalpel drawer
docker ps -a
# postgresql is a metasploit requirement and needs kickstart in kali
# docker exec scalpel service posgresql start

# validate metasploit health
metasploitHealth="$(docker exec scalpel msfupdate)"

# metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
# echo $metasploitHealth

# fetch gpg2 pubkey
# gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB