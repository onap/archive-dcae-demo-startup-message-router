#!/bin/bash

set -e

# docker registry configurations
# all docker container dependencies are now from docker hub, no need for our own any more 

# do not change this, it is already matched with the git repo file structure
DOCKER_FILE_DIR="./docker_files"

# commands to run docker and docker-compose
DOCKER_COMPOSE_EXE="/opt/docker/docker-compose"
DOCKER_EXE="docker"


cd ${DOCKER_FILE_DIR} 

echo "prep any files with local configurations"
if ls __* 1> /dev/null 2>&1; then    
   IP_DOCKER0=`ifconfig docker0 |grep "inet addr" | cut -d: -f2 |cut -d" " -f1`
   TEMPLATES=`ls -1 __*`
   for TEMPLATE in $TEMPLATES
   do 
      FILENAME=${TEMPLATE//_}
      if [ ! -z ${IP_DOCKER0} ]; then
         sed -e "s/{{ ip.docker0 }}/${IP_DOCKER0}/" $TEMPLATE > $FILENAME
      fi
   done
fi

echo "starting docker operations"
#${DOCKER_EXE} login --username=${DOCKER_REGISTRY_USERNAME} --password=${DOCKER_REGISTRY_PASSWORD} ${DOCKER_REGISTRY}
${DOCKER_COMPOSE_EXE} up -d
