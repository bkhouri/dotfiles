#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GIT_DIR=${HOME}/Documents/git
GIT_HELPERS_DIR=${HOME}/bin/work/git-helpers

function printUsage() {
    echo ""
    echo "This script is used to install work related tools."
    echo ""
    echo "${0}"
    # echo "${0} [OPTIONS]"
    # echo ""
    # echo "Options:"
    # echo ""
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
        *)
            # unknown option
            echo "Unknown Option: $1"
            printUsage
            exit 1
            ;;
    esac
done

function installGitHelpers() {
    echo ""
    read -n1 -p "Did you visually confirm this computers public SSH key is added to github.pie.apple.com? [Y/n] " REPLY
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        cat <<< "Installing git helpers"
        git clone git@github.pie.apple.com:alan-falloon/git-helpers.git  ${GIT_HELPERS_DIR}

    else
        false
    fi
}

# GIT_HELPERS_DIR=${HOME}/bin/work
# set -x
if [ ! -d ${GIT_HELPERS_DIR} ] ; then
    installGitHelpers
    while [ $? -ne 0 ]; do
        installGitHelpers
    done
fi


BREW_INSTALL_TOOLS=(
    buildifier
    # buildozer
)

for tool in "${BREW_INSTALL_TOOLS[@]}"
do
    if [ ! -f "$(which ${tool})" ]; then
        brew install ${tool}
        if [ $? -ne 0 ] ; then
            # We may have hit case where some path don't have the right permissions
            echo "Failed to install ${tool} using brew.  If the failure was a result of incorrect"
            echo "permissions, enter your local account password to update the ownership of"
            echo "files/directories I should have access to."
            set -x
            sudo chown -R $(whoami) /usr/local/Frameworks /usr/local/bin /usr/local/etc /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/share/doc /usr/local/share/locale /usr/local/share/man /usr/local/share/man/man1 /usr/local/share/man/man4 /usr/local/share/man/man5 /usr/local/share/man/man7 /usr/local/share/man/man8
            set +x
            brew install ${tool}
        fi
    fi
done
