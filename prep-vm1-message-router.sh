#!/bin/bash

set -e

# Assuming running this script from a VM that is spun up by Open eCOMP HEAT template.  
# Hence it has the git and docker registry configurations provided as files under /opt/config 

if [ -e /opt/config/gitlab_repo.txt ]; then
  export GIT_PATH=`cat cat /opt/config/gitlab_repo.txt`
fi
if [ -e /opt/config/gitlab_username.txt ]; then
  export GIT_USERNAME=`cat /opt/config/gitlab_username.txt`
fi
if [ -e /opt/config/gitlab_password.txt ]; then
  export GIT_PASSWORD=`cat /opt/config/gitlab_password.txt`
fi
if [ -e /opt/config/gitlab_branch.txt ]; then
  export GIT_BRANCH=`cat /opt/config/gitlab_branch.txt`
else
  export GIT_BRANCH="master"
fi



#https://23.253.149.175/lj1412/dcae-startup-vm-message-router


git -c http.sslVerify=false clone -b ${GIT_BRANCH} https://${GIT_USERNAME}:${GIT_PASSWORD}@${GIT_PATH}/dcae-startup-vm-message-router.git
cd dcae-startup-vm-message-router && ./deploy.sh

