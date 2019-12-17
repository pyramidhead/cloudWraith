#!/bin/bash
# fuck you and the horse you rode in on

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker system prune -af
git reset --hard
chmod 755 pull.sh
chmod 755 reset.sh