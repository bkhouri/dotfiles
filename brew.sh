#!/usr/bin/env bash -x

# Install brew
BREW_CMD=$(which brew)
if [ -z "${BREW_CMD}" ] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

set -x
# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update --verbose

# Upgrade any already-installed formulae.
brew upgrade --verbose

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
#brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
#brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
#if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
#  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
#  chsh -s /usr/local/bin/bash;
#fi;

# brew install thefuck  # https://github.com/nvbn/thefuck

#brew install readline

# Install fun tools
brew install fortune # https://opensource.com/article/18/12/linux-toy-fortune
brew install cowsay  # https://opensource.com/article/18/12/linux-toy-cowsay
brew install boxes   #
brew install sl      #
brew install lolcat  # https://opensource.com/article/18/12/linux-toy-lolcat
brew install gawk    #
brew install nyancat # https://opensource.com/article/18/12/linux-toy-nyancat
brew install nsnake
brew install cmatrix # https://opensource.com/article/18/12/linux-toy-cmatrix

# record terminal
brew install asciinema  # https://asciinema.org

# other useful tools, all from https://dev.to/_darrenburns/10-tools-to-power-up-your-command-line-4id4
brew install z
brew install fzf
brew install exa
brew install ripgrep

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
#brew install gnupg

# Install more recent versions of some macOS tools.
#brew install vim --with-override-system-vi
#brew install grep
#brew install openssh
#brew install screen
#brew install homebrew/php/php56 --with-gmp

# Install font tools.
#brew tap bramstein/webfonttools
#brew install sfnt2woff
#brew install sfnt2woff-zopfli
#brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
#brew install aircrack-ng
#brew install bfg
#brew install binutils
#brew install binwalk
#brew install cifer
#brew install dex2jar
#brew install dns2tcp
#brew install fcrackzip
#brew install foremost
#brew install hashpump
#brew install hydra
#brew install john
#brew install knock
#brew install netpbm
#brew install nmap
#brew install pngcheck
#brew install socat
#brew install sqlmap
#brew install tcpflow
#brew install tcpreplay
#brew install tcptrace
#brew install ucspi-tcp # `tcpserver` etc.
#brew install xpdf
#brew install xz

# Install other useful binaries.
brew install bat
brew install prettyping
#brew install ack
##brew install exiv2
brew install git
brew install git-lfs
brew install git-review  # automates and streamlines some of the tasks involved with submitting local changes to a Gerrit server for review

# Install gitbatch --> Ref: https://github.com/isacikgoz/gitbatch
brew tap isacikgoz/taps
brew install gitbatch

#brew install bash-git-prompt
#brew install imagemagick --with-webp
#brew install lua
#brew install lynx
#brew install p7zip
#brew install pigz
#brew install pv
#brew install rename
#brew install rlwrap
#brew install ssh-copy-id
brew install sqlite
brew install tree
#brew install telnet
#brew install vbindiff
#brew install zopfli

# Work tools
brew install maven
brew install python
brew install pipenv
brew install node@12
# Node version 12 env vars based in installation via brew
echo '' >> ~/.bash_profile
echo '# Node version 12 env vars based in installation via brew - this section was generated via the brew.sh script in the dotfiles repo'  >> ~/.bash_profile
echo 'export PATH="/usr/local/opt/node@12/bin:${PATH}"' >> ~/.bash_profile
echo 'export LDFLAGS="-L/usr/local/opt/node@12/lib"' >> ~/.bash_profile
echo 'export CPPFLAGS="-I/usr/local/opt/node@12/include"' >> ~/.bash_profile
echo '' >> ~/.bash_profile
brew install repo
# brew tap bazelbuild/tap
# brew install bazelbuild/tap/bazel
brew install yarn
brew install yarn-completion

brew install graphviz
# brew install go
# brew install maven-completion
brew install pip-completion
brew install brew-cask-completion
# brew install docker-compose-completion
# brew install docker-completion
# brew install kubernetes-cli
# brew install kubernetes-helm
# brew cask install mattermost

brew install ctop  # docker container top command  https://github.com/bcicen/ctop
brew install brew-cask-completion

# Install minikube
#brew cask install minikube
#brew install docker-machine-driver-hyperkit

## docker-machine-driver-hyperkit need root owner and uid
#sudo chown root:wheel /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit
#sudo chmod u+s /usr/local/opt/docker-machine-driver-hyperkit/bin/docker-machine-driver-hyperkit
### DONE minikube install

# Install diff-pdf https://github.com/vslavik/diff-pdf
brew cask install xquartz
brew install diff-pdf

# Remove outdated versions from the cellar.
brew cleanup


#adns
#cairo
#fontconfig
#fortune
#freetype
#gawk
#gdbm
#gettext
#glib
#gmp
#gnupg
#gnutls
#jpeg
#libassuan
#libffi
#libgcrypt
#libgpg-error
#libksba
#libpng
#libtasn1
#libtiff
#libunistring
#libusb
#little-cms2
#mockserver
#mpfr
#nettle
#npth
#nsnake
#nspr
#nss
#openjpeg
#openssl
#p11-kit
#pcre
#pcre2
#pinentry
#pixman
#poppler
#python
#wxmac
#xz
