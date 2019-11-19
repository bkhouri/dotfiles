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
	echo "   --no-brew    When set, will not install brew formulaes"
	echo "   --xcode      When set, it will install xcode"
    echo ""
}


function runBashScript {
    if [ -f "${1}" ] ; then
        bash $@
    fi
}

function installGitBash {
    local outfile
    local destination_path
    echo -n "Installing gitbatch..."
    # Download gitbatch https://github.com/isacikgoz/gitbatch
    outfile=${HOME}/Downloads/gitbatch.tar.gz
    destination_path=${HOME}/Documents/bin
    mkdir -p $(dirname ${outfile})
    mkdir -p ${destination_path}
    curl  --silent  --location https://github.com/isacikgoz/gitbatch/releases/download/v0.4.1/gitbatch_0.4.1_darwin_amd64.tar.gz -o ${outfile}
    tar -C ${destination_path} -xzf ${outfile}
    rm -rf ${outfile}
    unset outfile destination_dir
    gitbatch=$(which gitbatch)
    echo " installed in ${gitbatch}"
    #go get -u github.com/isacikgoz/gitbatch
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
        --xcode)
            shift
            INSTALL_XCODE=true
            ;;
		--no-brew)
		   shift
		   IGNORE_BREW_INSTALL=true
		   ;;
        *)
            # unknown option
            echo "Unknown Option: $1"
            printUsage
            exit 1
            ;;
    esac
done

if [ -z "${IGNORE_BREW_INSTALL}" ]; then
	runBashScript ${BASEDIR}/brew.sh
fi

BASH_SEAFLY_PROMPT_DIR=${GIT_DIR}/bash-seafly-prompt
if [ ! -d "${BASH_SEAFLY_PROMPT_DIR}" ] ; then
    mkdir -p ${BASH_SEAFLY_PROMPT_DIR}
    git clone https://github.com/bluz71/bash-seafly-prompt.git ${BASH_SEAFLY_PROMPT_DIR}
fi

if [ -z "$(which gitbatch)" ] ; then
    installGitBash
fi

if [ -n "${BOOTSTRAP}" ] ; then
    runBashScript ${BASEDIR}/bootstrap.sh
fi

if [ -n "${INSTALL_XCODE}" ] ; then
	echo "Installing xcode..."
	xcode-select --install
	return_code=$(echo $?)
	if [ ${return_code} -ne 0 ]; then
		echo "Failed to instal xcode.  Return code was ${return_code}."
	fi
fi

unset runBashScript
unset installGitBash
unset return_code
