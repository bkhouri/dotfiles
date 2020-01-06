#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

#git pull origin master > /dev/null 2>&1

function doIt() {
    INSTALL_WORK=${1}
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude ".gitignore" \
        --exclude ".idea" \
        --exclude "*.iml" \
        --exclude "*.sh" \
        --exclude ".work" \
        -avh --no-perms . ~;
    #source ${HOME}/.bash_profile;

    if [ "${INSTALL_WORK}" == "true" ] ; then
        rsync ".work" ~
    fi
}

while [[ $# > 0 ]]
do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --work)
            WORK=true
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


if [ "${FORCE}" == "true" ]; then
    doIt ${WORK};
else
    read -p "This may overwrite existing files in your home directory. Are you sure? [y/N] " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt ${WORK};
    fi;
fi;
unset doIt;
