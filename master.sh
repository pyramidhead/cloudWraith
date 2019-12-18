#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# start mongo container and validate in docker
docker pull mongo:4.0.4;
docker run -d --rm --name satchel -d mongo:4.0.4;
docker ps -a;

# validate mongo service availability
sleep 5
mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
until [[ $mongoHealth =~ "Implicit" ]]; do
	echo "Mongo not awake yet."
	sleep 1
	mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
done
echo "Mongo awake."