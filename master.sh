#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# start mongo container and validate in docker
docker pull mongo:4.0.4;
docker run -d --rm --name satchel -d mongo:4.0.4;
docker ps -a;

# validate mongo service availability
mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit session")"
while -z $mongoHealth do;
	echo "Gave mongo coffee. Give him a minute."
	sleep 5;
done;
echo "Mongo is awake."
# until nc -z -v -w30 $satchelHost 27017; do
#	sleep 5;
#	echo "Poking mongo. He's growling."
	# define query from successful health check
	# mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())")"
	# another until loop for success case
		# sleep 5;
		# echo "Gave mongo coffee. Give him a moment."
# done;