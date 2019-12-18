#!/bin/bash
# master script to operate a containerized pentesting architecture organized around dorking threat vectors identified with metasploit
# prerequisites: docker

# start mongo container and validate in docker
docker pull mongo:4.0.4
docker run -d --rm --name satchel -d mongo:4.0.4
docker ps -a

# validate mongo service availability
sleep 1
mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
until [[ $mongoHealth =~ "Implicit" ]]; do
	sleep 1
	mongoHealth="$(docker exec satchel mongo --eval "printjson(db.serverStatus())" | grep "Implicit")"
done

# start metasploit container and validate in docker
docker run -d --rm --name scalpel -it -p 443:443 remnux/metasploit
docker ps -a

# install and validate ruby
rubyHealth="$(docker exec scalpel ruby -v | grep "file not found")"
echo $rubyHealth
if [[ $rubyHealth =~ "file not found" ]]; do
	# things
done

# validate metasploit service availability
# sleep 5
# metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
# echo $metasploitHealth