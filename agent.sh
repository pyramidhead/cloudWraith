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
if [[ $rubyHealth =~ "file not found" ]]; then
	# ruby install
	docker exec scalpel apt-get update
	docker exec scalpel apt-get -fy install fontconfig-config fonts-dejavu-core libfontconfig1 libfreetype6 libruby1.9.1 libruby1.9.1-dbg libtcl8.5 libtcltk-ruby1.9.1 libtk8.5 libxft2 libxrender1 libxss1 ri1.9.1 ruby ruby1.9.1 ruby1.9.1-dev ruby1.9.1-examples ruby1.9.1-full x11-common
	docker exec scalpel apt-get -fy install ruby-full
fi
# ruby validate
rubyHealth="$(docker exec scalpel ruby -v | grep "revision")"
echo $rubyHealth
if [[ $rubyHealth =~ "revision" ]]; then
	echo "Ruby installed."
elif [[ $rubyHealth != *"revision"* ]]; then
	echo "Ruby install failed. Metasploit functions disabled. Troubleshooting required."
	rubyDown=1
fi

# validate metasploit service availability
if [[ $rubyDown == 1 ]]; then
	echo "Metasploit down because of ruby dependency - fix that."
elif [[ $rubyHealth != *"revision"* ]]; then
	echo "We're going to validate metasploit right here."
fi
# metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
# echo $metasploitHealth