#!/bin/bash
DOCKER_IMAGE=jenkins/jenkins:lts
DOCKER_CONTAINER_NAME=jenkins

LOCAL_JENKINS_VOLUME=${HOME}/Documents/jenkins_home
PREFERRED_CONTAINER_ENGINE=vessel

function printUsage {    echo ""
    echo "This script starts a local Jenkins instance to be used for local development."
    echo ""
    echo "${0} [OPTIONS]"
    echo ""
    echo "Options:"
    echo "   --container  Use this as the container engine (default: ${PREFERRED_CONTAINER_ENGINE})"
    echo ""
}

while [[ $# > 0 ]]; do
    case $1 in
    --container)
        shift # past argument
        PREFERRED_CONTAINER_ENGINE=${1}
        shift
        ;;
    *)
        # unknown option
        echo "Unknown Option: $1"
        printUsage
        exit 1
        ;;
    esac
done

preferred_cmd=$(command -v ${PREFERRED_CONTAINER_ENGINE})
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

