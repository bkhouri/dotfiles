#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

#git pull origin master > /dev/null 2>&1

function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        --exclude ".gitignore" \
        --exclude ".idea" \
        --exclude "*.iml" \
        --exclude "*.sh" \
        -avh --no-perms . ~;
    #source ${HOME}/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? [y/N] " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
