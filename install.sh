#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GIT_DIR=${HOME}/Documents/git

function printUsage() {
    echo ""
    echo "This script is used to build and run the robot remote server locally."
    echo ""
    echo "${0} [OPTIONS]"
    echo ""
    echo "Options:"
    echo "   --bootstrap  When set, will bootstrap all the dot files in this repository"
    echo ""
}


function runBashScript {
    if [ -f "${1}" ] ; then
        echo "bash $@"
    fi
}
# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 0 ]]
do
    case $1 in
        --bootstrap)
            shift # past argument
            BOOTSTRAP=true
            ;;
        *)
            # unknown option
            echo "Unknown Option: $1"
            printUsage
            exit 1
            ;;
    esac
done

runBashScript ${BASEDIR}/brew.sh

BASH_SEAFLY_PROMPT_DIR=${GIT_DIR}/bash-seafly-prompt
if [ ! -d "${BASH_SEAFLY_PROMPT_DIR}" ] ; then
    mkdir -p ${BASH_SEAFLY_PROMPT_DIR}
    git clone https://github.com/bluz71/bash-seafly-prompt.git ${BASH_SEAFLY_PROMPT_DIR}
fi

if [ -n "${BOOTSTRAP}" ] ; then
  runBashScript ${BASEDIR}/bootstrap.sh
fi
