#!/usr/bin/env bash -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR=${HOME}/Documents/git
INSTALL_WORK_SCRIPT="${BASEDIR}/install-work-exclude.sh"
BREW_INSTALL_SCRIPT="${BASEDIR}/brew-exclude.sh"

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
    echo "   --ohmyzsh    When set, install OH MY ZSH"
    echo "   --work       When set, run script ${INSTALL_WORK_SCRIPT}"
    echo ""
}

function runBashScript() {
    if [ -f "${1}" ]; then
        bash $@
    fi
}

function installGitBash() {
    local outfile
    local destination_path
    cat <<<"Installing gitbatch..."
    # Download gitbatch https://github.com/isacikgoz/gitbatch
    outfile=${HOME}/Downloads/gitbatch.tar.gz
    destination_path=${HOME}/Documents/bin
    mkdir -p $(dirname ${outfile})
    mkdir -p ${destination_path}
    curl --silent --location https://github.com/isacikgoz/gitbatch/releases/download/v0.4.1/gitbatch_0.4.1_darwin_amd64.tar.gz -o ${outfile}
    tar -C ${destination_path} -xzf ${outfile}
    rm -rf ${outfile}
    unset outfile destination_dir
    gitbatch=$(which gitbatch)
    cat <<<" installed at ${gitbatch}"
    #go get -u github.com/isacikgoz/gitbatch
}

function installPowerLineFontAndShell() {
    # clone
    echo "Installing Powerline Font and shell"
    set -x
    git clone https://github.com/powerline/fonts.git --depth=1
    # install
    (
        cd fonts
        ./install.sh
    )
    # clean-up a bit
    rm -rf fonts
    set +x
}

function boostrap {
    if [ -n "${BOOTSTRAP}" ]; then
        cat <<<"Bootstraping..."
        BOOTSTRAP_ARGS=()
        if [ ${INSTALL_WORK} ]; then
            BOOTSTRAP_ARGS+=(--work)
        fi
        runBashScript ${BASEDIR}/bootstrap.sh "${BOOTSTRAP_ARGS[@]}"
    fi
}

function installOhMyZsh() {
    echo "Installing OH MY ZSH..."
    INSTALL_SCRIPT=${HOME}/Downloads/install_oh_my_zsh.sh
    mkdir -p $(dirname ${INSTALL_SCRIPT}})
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh --output "${INSTALL_SCRIPT}"
    echo "[--------------- START OF OH_MY_ZSH INSTALL SCRIPT ---------------]"
    \cat ${INSTALL_SCRIPT}
    echo "[--------------- END OF OH_MY_ZSH INSTALL SCRIPT ---------------]"
    echo ""
    read -p "Are you sure you want to install OH MY ZSH? [N/y]" -n 1 -r
    echo # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # See https://gist.github.com/kevin-smets/8568070
        installPowerLineFontAndShell
        sh ${INSTALL_SCRIPT}
        # install powerline10k
        git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        # Install zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        # Install zsh syntax highlighting https://github.com/zsh-users/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo "Skipping installing OH MY ZSH"
    fi
    rm "${INSTALL_SCRIPT}"
}

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 0 ]]; do
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
    --ohmyzsh)
        shift
        INSTALL_OHMYZSH=true
        ;;
    --work)
        shift
        INSTALL_WORK=true

        ;;
    *)
        # unknown option
        echo "Unknown Option: $1"
        printUsage
        exit 1
        ;;
    esac
done

boostrap

if [ -n "${INSTALL_WORK}" ]; then
    if [ -f "${INSTALL_WORK_SCRIPT}" ]; then
        ${INSTALL_WORK_SCRIPT}
    else
        echo "WARNING: Work install script not found: ${INSTALL_WORK_SCRIPT}"
    fi
fi


if [ -z "${IGNORE_BREW_INSTALL}" ]; then
    echo "Installing BREW packages"
    runBashScript "${BREW_INSTALL_SCRIPT}"
    echo "DONE brew installation"
fi

BASH_SEAFLY_PROMPT_DIR=${GIT_DIR}/bash-seafly-prompt
if [ ! -d "${BASH_SEAFLY_PROMPT_DIR}" ]; then
    mkdir -p ${BASH_SEAFLY_PROMPT_DIR}
    git clone https://github.com/bluz71/bash-seafly-prompt.git ${BASH_SEAFLY_PROMPT_DIR}
fi

# if [ -z "$(which gitbatch)" ] ; then
#     installGitBash
# fi

if [ -n "${INSTALL_XCODE}" ]; then
    echo "Installing xcode..."
    xcode-select --install
    return_code=$(echo $?)
    if [ ${return_code} -ne 0 ]; then
        echo "Failed to instal xcode.  Return code was ${return_code}."
    fi
fi

if [ -n "${INSTALL_OHMYZSH}" ]; then
    installOhMyZsh
fi

boostrap


unset boostrap
unset runBashScript
unset installGitBash
unset installOhMyZsh
unset installPowerLineFontAndShell
unset return_code
