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
	docker exec scalpel apt-get -fy install fontconfig-config fonts-dejavu-core libfontconfig1 libfreetype6 libruby2.3.0 libruby2.3.0-dbg libtcl8.5 libtcltk-ruby2.3.0 libtk8.5 libxft2 libxrender1 libxss1 ri2.3.0 ruby ruby2.3.0 ruby2.3.0-dev ruby2.3.0-examples ruby2.3.0-full x11-common
	docker exec scalpel apt-get -fy install ruby-full
	docker ps -a
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
elif [[ $rubyHealth == *"revision"* ]]; then
	# validate metasploit health
	metasploitHealth="$(docker exec scalpel msfupdate)"
fi
# metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
# echo $metasploitHealth