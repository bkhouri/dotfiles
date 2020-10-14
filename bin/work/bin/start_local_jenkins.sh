#!/bin/bash -e
DOCKER_IMAGE=jenkins/jenkins:lts
DOCKER_CONTAINER_NAME=jenkins

LOCAL_JENKINS_VOLUME=${HOME}/Documents/jenkins_home

mkdir -p "${LOCAL_JENKINS_VOLUME}"

set -x
docker pull "${DOCKER_IMAGE}"
docker run  --rm --name "${DOCKER_CONTAINER_NAME}" \
            --publish 8080:8080 \
            --publish 50000:50000 \
            --network host \
            --volume "${LOCAL_JENKINS_VOLUME}":/var/jenkins_home \
           "${DOCKER_IMAGE}"

