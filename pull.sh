#!/bin/bash
# refresh codebase and prepare for redeploy

git reset --hard
git pull
chmod 755 agent.sh
chmod 755 pull.sh
chmod 755 reset.sh
