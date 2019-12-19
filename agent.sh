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
docker exec scalpel apt-get update && install -fy debugedit gnupg2 libelf1 libnspr4 libnss3 libnss3-nssdb librpm3 librpmbuild3 librpmio3 librpmsign1 libsqlite0 python-libxml2 python-pycurl python-rpm python-sqlite python-sqlitecachec python-urlgrabber rpm rpm-common rpm2cpio
rubyHealth="$(docker exec scalpel ruby -v | grep "file not found")"
echo $rubyHealth
if [[ $rubyHealth =~ "file not found" ]]; then
	# ruby install
	docker exec scalpel apt-get -fy install yum yum-utils
	# sometimes this call fails and stalls, may need handling for that
	docker exec scalpel command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
	docker exec scalpel command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
	docker exec scalpel curl -L get.rvm.io | bash -s stable
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
docker ps -a

# validate metasploit service availability
if [[ $rubyDown == 1 ]]; then
	echo "Metasploit down because of ruby dependency - fix that."
elif [[ $rubyHealth == *"revision"* ]]; then
	# validate metasploit health
	metasploitHealth="$(docker exec scalpel msfupdate)"
fi
# metasploitHealth="$(docker exec scalpel msf > help | grep "Description")"
# echo $metasploitHealth

# fetch gpg2 pubkey
# gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB