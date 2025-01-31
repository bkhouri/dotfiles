#!/usr/bin/env bash -e

WORK_GIT_CONFIG=".gitconfig.work"

(
    cd "$(dirname "${BASH_SOURCE}")"

    #git pull origin master > /dev/null 2>&1

    function printUsage() {
        echo ""
        echo "This is the bootstrap script."
        echo ""
        echo "${0} [OPTIONS]"
        echo ""
        echo "Options:"
        echo "   -f|--force  When set, will not prompt the user for confirmation"
        echo "   --work      When set, will synchronize work-related files"
        echo ""
    }

    function doIt() {
        INSTALL_WORK=${1}
        echo "Synchronizing files..."
        rsync --exclude ".git/" \
            --exclude ".DS_Store" \
            --exclude ".osx" \
            --exclude "README.md" \
            --exclude "LICENSE-MIT.txt" \
            --exclude ".gitignore" \
            --exclude ".idea" \
            --exclude "*.iml" \
            --exclude "*-exclude.sh" \
            --exclude "*work" \
            --verbose --archive --human-readable . ~
        #source ${HOME}/.bash_profile;
        POST_BOOTSTRAP="./post-bootstrap-exclude.sh"
        if [ -f "${POST_BOOTSTRAP}" ]; then
            source "${POST_BOOTSTRAP}"
        fi

        if [ "${INSTALL_WORK}" == "true" ]; then
            echo "Synchronizing work realted files..."
            set -x
            rsync --verbose --archive --human-readable --no-perms "bin/work" ~/bin
            rsync --verbose --archive --human-readable --no-perms "${WORK_GIT_CONFIG}" ~
            POST_BOOTSTRAP_WORK="./post-bootstrap-work-exclude.sh"
            if [ -f "${POST_BOOTSTRAP_WORK}" ]; then
                source "${POST_BOOTSTRAP_WORK}"
            fi

            set +x
            echo "****************************"
            echo "* Update git user for work *"
            echo "****************************"
            read -p "Enter work name: "
            work_name=$(echo "${REPLY}" | xargs)  # trim leading and trailing spaces
            git config --file ~/${WORK_GIT_CONFIG} user.name "${work_name}"
            read -p "Enter work email address: "
            work_email_address=$(echo "${REPLY}" | xargs)  # trim leading and trailing spaces
            git config --file ~/${WORK_GIT_CONFIG} user.email "${work_email_address}"

            echo "Work git configuraiton file setup"
            echo "  - Name : '${work_name}'"
            echo "  - email: '${work_email_address}'"
            set -x
        fi
    }

    while [[ $# > 0 ]]; do
        case $1 in
        --force | -f)
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
        doIt ${WORK}
    else
        read -p "This may overwrite existing files in your home directory. Are you sure? [y/N] " -n 1
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            doIt ${WORK}
        fi
    fi
    unset doIt

)
