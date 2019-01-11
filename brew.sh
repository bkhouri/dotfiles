#!/usr/bin/env bash -x

# Install brew
BREW_CMD=$(which brew)
if [ -z "${BREW_CMD}" ] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

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
brew install bash-git-prompt
#brew install imagemagick --with-webp
#brew install lua
#brew install lynx
#brew install p7zip
#brew install pigz
#brew install pv
#brew install rename
#brew install rlwrap
#brew install ssh-copy-id
brew install tree
#brew install vbindiff
#brew install zopfli


# Install diff-pdf https://github.com/vslavik/diff-pdf
brew cask install xquartz
brew install diff-pdf

# Remove outdated versions from the cellar.
brew cleanup
