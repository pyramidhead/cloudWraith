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
# install metasploit
docker exec -i scalpel ./msfinstall
# validate container status
docker ps -a
# health check metasploit app
metasploitAppHealth="$(docker exec scalpel msfconsole | grep "encoders")"
until [[ $metasploitAppHealth =~ "encoders" ]]; do
	sleep 1
	metasploitHealth="$(docker exec scalpel msfconsole | grep "encoders")"
done
# initialize database
docker exec scalpel msfdb init
# health check metasploit db
metasploitCheck="$(docker exec scalpel msfconsole)"
echo $metasploitCheck
metasploitDBRegistryCheck="$(docker exec scalpel msfconsole | grep "No database support")"
if [[ $metasploitDBRegistryCheck =~ "No database support" ]]; then
	echo "Metasploit database definition missing. Terminating."; exit 1;
elif [[ $metasploitDBRegistryCheck =~ "using system database" ]]; then
	echo "Metasploit database up. Proceeding."
fi

# build a node.js container that runs a web interface; call it wristpad

# build a node.js container that runs our natual language search engine; call it brainpal