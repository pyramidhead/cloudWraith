#!/bin/bash
# master script to operate a containerized pentesting architecture utilizing various resources to identify vulnerabilities
# prerequisites: docker

# build persistent shared storage
docker volume create backpack
docker volume inspect backpack

# build and validate mongo container
docker image build -t drawer ./mongo
docker run -d --rm --mount source=backpack,target=/backpack --name legdrop drawer
mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
until [[ $mongoHealth =~ "Implicit" ]]; do
	sleep 1
	mongoHealth="$(docker exec legdrop mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
done

# build and validate kali container
docker image build -t drawer ./kali
docker run -t -d --rm --mount source=backpack,target=/backpack --name scalpel drawer
kaliHealth="$(docker exec scalpel cat /etc/os-release | grep "ID_LIKE")"
until [[ $kaliHealth =~ "ID_LIKE" ]]; do
	sleep 3
	kaliHealth="$(docker exec scalpel cat /etc/os-release | grep "ID_LIKE")"
done
echo "goddess Kali has awoken"
# health check metasploit app
metasploitAppHealth="$(docker exec scalpel msfconsole | grep "encoders")"
until [[ $metasploitAppHealth =~ "encoders" ]]; do
	sleep 3
	metasploitHealth="$(docker exec scalpel msfconsole | grep "encoders")"
done
echo "goddess Kali has had her coffee"
# health check metasploit db
metasploitDBRegistryCheck="$(docker exec scalpel msfconsole | grep "No database support")"
if [[ $metasploitDBRegistryCheck =~ "No database support" ]]; then
	echo "Metasploit database definition missing. Terminating."; exit 1;
fi
echo "goddess Kali has done her crossword"

# build and validate wristpad
# initial spec: to start, this needs to present a web interface, allow targeting of a single ip address, and import json data in a useful format into mongo
# research requirement: how to dockerize a node.js given a simple code example

# build a node.js container that runs our natural language search and prioritization engine; call it brainpal