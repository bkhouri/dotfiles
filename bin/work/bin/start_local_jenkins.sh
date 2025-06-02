#!/bin/bash
DOCKER_IMAGE=jenkins/jenkins:lts
DOCKER_CONTAINER_NAME=jenkins

LOCAL_JENKINS_VOLUME=${HOME}/Documents/jenkins_home
PREFERRED_CONTAINER_ENGINE=vessel
DOCKER_RUN_ARGS=

function printUsage {    echo ""
    echo "This script starts a local Jenkins instance to be used for local development."
    echo ""
    echo "${0} [OPTIONS]"
    echo ""
    echo "Options:"
    echo "   --container  <container>  Use this as the container engine (default: ${PREFERRED_CONTAINER_ENGINE})"
    echo "   --docker-run-args ARGS"
    echo ""
}

while [[ $# > 0 ]]; do
    case $1 in
    --container)
        shift
        PREFERRED_CONTAINER_ENGINE=${1}
        ;;
    --docker-run-args)
        shift
        DOCKER_RUN_ARGS=${1}
        ;;
    *)
        # unknown option
        echo "Unknown Option: $1"
        printUsage
        exit 1
        ;;
    esac
    shift
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
            ${DOCKER_RUN_ARGS} \
           "${DOCKER_IMAGE}"

