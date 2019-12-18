#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# start mongo container and validate in docker
docker pull mongo:4.0.4;
docker run -d --rm --name satchel -d mongo:4.0.4;
docker ps -a;

# validate mongo service availability
mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit session")"
while [ -z "$mongoHealth" ]; do
	sleep 1
	echo "Mongo not awake yet."
	mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit session")"
done