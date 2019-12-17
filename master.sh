#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# start mongo container and validate
docker pull mongo:4.0.4;
docker run -d --rm --name satchel -d mongo:4.0.4;
docker ps -a;

# modify this for mongo
# until nc -z -v -w30 $satchelHost 27017; do
#	sleep 5;
#	echo "poking mongo. he's growling."
#	mongoExternalQuery="$(mysql -uroot -pSQUIRREL -e 'use performance_schema')"
# done

# validate mongo container availability
# ./justPawn.sh