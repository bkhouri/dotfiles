#!/bin/bash
DOCKER_IMAGE=jenkins/jenkins:lts
DOCKER_CONTAINER_NAME=jenkins

LOCAL_JENKINS_VOLUME=${HOME}/Documents/jenkins_home
preferred_container_engine=vessel
preferred_cmd=$(command -v ${preferred_container_engine})
container_cmd=$(command -v docker)
if [[ -n "${preferred_cmd}" ]] ; then
    container_cmd=$preferred_cmd
fi
set -e
mkdir -p "${LOCAL_JENKINS_VOLUME}"

set -x
$container_cmd pull "${DOCKER_IMAGE}"
$container_cmd run  --rm --name "${DOCKER_CONTAINER_NAME}" \
            --publish 8080:8080 \
            --publish 50000:50000 \
            --volume "${LOCAL_JENKINS_VOLUME}":/var/jenkins_home \
           "${DOCKER_IMAGE}"

