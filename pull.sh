#!/bin/bash
# refresh codebase and prepare for redeploy

git reset --hard
git pull
chmod 755 master.sh
chmod 755 pull.sh
chmod 755 reset.sh