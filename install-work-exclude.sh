#!/usr/bin/env bash -e
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR=${HOME}/Documents/git
GIT_HELPERS_DIR=${HOME}/bin/work/git-helpers
BAZEL_LSP_BIN=${HOME}/bin/work/bin/bazel-lsp
BAZEL_LSP_VERSION="0.6.0"

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

function installRust() {
    local RUST_INSTALL_SCRIPT="${HOME}/Downloads/install_rustup.sh"
    mkdir -p $(dirname "${RUST_INSTALL_SCRIPT}")
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs --output "${RUST_INSTALL_SCRIPT}"
    echo "[--------------- START OF RUSTUP INSTALL SCRIPT ---------------]"
    \cat "${RUST_INSTALL_SCRIPT}"
    echo "[--------------- END OF RUSTUP INSTALL SCRIPT ---------------]"
    echo ""
    echo "Installing Rust per https://www.rust-lang.org"
    read -p "Are you sure you want to install RUSTUP? [N/y]" -n 1 -r
    echo # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sh "${RUST_INSTALL_SCRIPT}"
    else
        echo "Skipping installing RUSTUP"
    fi
    rm "${RUST_INSTALL_SCRIPT}"
}

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 0 ]]; do
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
    read -n1 -p "Did you visually confirm this computers public SSH key is added to github.pie.apple.com? [y/N] " REPLY
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat <<<"Installing git helpers"
        set -x
        git clone git@github.pie.apple.com:alan-falloon/git-helpers.git ${GIT_HELPERS_DIR}
        set +x
    else
        false
    fi
}

# GIT_HELPERS_DIR=${HOME}/bin/work
# set -x
if [ ! -d ${GIT_HELPERS_DIR} ]; then
    installGitHelpers
    while [ $? -ne 0 ]; do
        installGitHelpers
    done
else
    set -x
    pushd "${GIT_HELPERS_DIR}"
    git pull
    popd
    set +x
fi

function installBazelLsp() {
    cat <<<"Installing bazel-lsp"
    set -x
    curl "https://github.com/cameron-martin/bazel-lsp/releases/download/v${BAZEL_LSP_VERSION}/bazel-lsp-${BAZEL_LSP_VERSION}-osx-arm64" --location --output "${BAZEL_LSP_BIN}"
    chmod +x ${BAZEL_LSP_BIN}
    set +x
}

if [ ! -d ${BAZEL_LSP_BIN} ]; then
    installBazelLsp
    while [ $? -ne 0 ]; do
        installBazelLsp
    done
fi

BREW_INSTALL_TOOLS=(
    bazelisk
    buildifier
    buildozer
    docker-compose-completion
    docker-completion
    go
    jfrog-cli
    secretive
    shellcheck
    shfmt
    withered-magic/brew/starpls
    # buildozer
    apple/aci/kcli
    apple/crypto-services/whisperctl
    kubectl
)

NPM_INSTALL_TOOLS=(
    npm
    jflint
    npm-check-updates
)

brew tap apple/aci
for tool in "${BREW_INSTALL_TOOLS[@]}"; do
    if [ ! -f "$(which ${tool})" ]; then
        set -x
        brew install ${tool}
        set +x
        if [ $? -ne 0 ]; then
            # We may have hit case where some path don't have the right permissions
            echo "Failed to install ${tool} using brew.  If the failure was a result of incorrect"
            echo "permissions, enter your local account password to update the ownership of"
            echo "files/directories I should have access to."
            set -x
            sudo chown -R $(whoami) /usr/local/Frameworks /usr/local/bin /usr/local/etc /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/share/doc /usr/local/share/locale /usr/local/share/man /usr/local/share/man/man1 /usr/local/share/man/man4 /usr/local/share/man/man5 /usr/local/share/man/man7 /usr/local/share/man/man8
            brew install ${tool}
            set +x
        fi
    fi
done

for tool in "${NPM_INSTALL_TOOLS[@]}"; do
    set -x
    npm install -g ${tool}
    set +x
done

BOOKMARKS_DIR=${HOME}/.bookmarks
(
    [ ! -d "${BOOKMARKS_DIR}" ] && mkdir -p ${BOOKMARKS_DIR}
    cd "${BOOKMARKS_DIR}"
    ln -s ~/Documents/git @git
    echo "Create symbolic link in \""${BOOKMARKS_DIR}"\" for each repository prefixed with @ symbol to aid bookmarks"
)
(
    /bin/bash -c "$(curl -fsSL https://adt.g.apple.com/adt)"
)
# installRust
echo "Configure default git email address:  git config --global user.email <work_email_address>"