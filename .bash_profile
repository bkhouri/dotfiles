# Add `~/bin` to the `$PATH`
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
for file in ~/.{bash_prompt,aliases}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

## Case-insensitive globbing (used in pathname expansion)
#shopt -s nocaseglob;

## Append to the Bash history file, rather than overwriting it
shopt -s histappend;

## Autocorrect typos in path names when using `cd`
#shopt -s cdspell;

## Enable some Bash 4 features when possible:
## * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
## * Recursive globbing, e.g. `echo **/*.txt`
#for option in autocd globstar; do
#    shopt -s "$option" 2> /dev/null;
#done;

## Add tab completion for many Bash commands
#if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
#    source "$(brew --prefix)/share/bash-completion/bash_completion";
#elif [ -f /etc/bash_completion ]; then
#    source /etc/bash_completion;
#fi;

## Enable tab completion for `g` by marking it as an alias for `git`
#if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
#    complete -o default -o nospace -F _git g;
#fi;

## Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
# complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
# complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;



BASH_ALIAS_FILE=${HOME}/.bash_alias
GIT_COMPLETION_FILE=${HOME}/.git-completion.bash
PROMPT_FILE=${HOME}/.prompt.bash

HISTTIMEFORMAT='%F %T  '
HISTSIZE=1000000

# Bind lines reference https://www.macworld.com/article/1146015/os-x/termhistory.html
bind '"[A":history-search-backward'
bind '"[B":history-search-forward'

export ORCA_VERSION=1.x-latest
export ROBOT_LOCAL_DEPLOYMENTS_DIR=${HOME}/Documents/CENX/deployments
export PATH=${HOME}/bin:${HOME}/Documents/bin:${HOME}/Documents/bin/platform-tools:${HOME}/Documents/git/scripts/bin:/usr/local/bin/:${PATH}
export PYTHONPATH=${HOME}/Documents/git/autotest

export PORT_NIFI=7777
export PORT_RETHINKDB=28080
export PORT_WILDFLY_DC=9990
export PORT_ZK=2181
export PORT_KAFKA=9092
export PORT_SOLR=8983
export PORT_PARKER_REPL=4081
export PORT_TERMINUS_REPL=4083
export PORT_NARANATHU_REPL=4015
export PORT_HEIMDALLR_REPL=4009
export PORT_APOLLO_REPL=4080




#function source_alias() {
#    [ -n "$(which thefuck)" ] && eval "$(thefuck --alias)"
#    if [ -f ${BASH_ALIAS_FILE} ] ; then
#        source ${BASH_ALIAS_FILE}
#    fi
#}
#
#source_alias

#[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
#[ -f $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion
##[ -f "$(brew --prefix)/share/bash-completion/bash_completion" ] && source $(brew --prefix)/share/bash-completion/bash_completion
#[ -f "${GIT_COMPLETION_FILE}" ] && source ${GIT_COMPLETION_FILE}
#[ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh

## declare an array variable
declare -a files_to_source=(
    "$(brew --prefix)/etc/profile.d/bash_completion.sh"
    #"$(brew --prefix)/etc/bash_completion"
    #"$(brew --prefix)/share/bash-completion/bash_completion"
    #${GIT_COMPLETION_FILE}
    "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
    "$(brew --prefix)/etc/profile.d/z.sh"
    )

## now loop through the above array
for file in "${files_to_source[@]}"
do
   [ -r "${file}" ] && [ -f "${file}" ] && source "${file}"
done



function getAbsolutePath() {
    if [ -n "$1" ] ; then
        LOCAL_VARIABLE="${1}" && echo $(cd $(dirname "$LOCAL_VARIABLE") && pwd -P)/$(basename "$LOCAL_VARIABLE")
    fi
}

### Orca stuff
if [ $(which docker-credential-osxkeychain) ]; then
    unlink $(which docker-credential-osxkeychain)
fi

#### Git stuff

function gc() {
    if [ -z "$1" ] ; then
        echo "*******************************************"
        echo "*   !!! WARNING !!!  Repo not cloned      *"
        echo "*******************************************"
        echo ""
        echo "Silly me!!! I need to specify a parameter, to repo to clone (without cenx-cf/)"
    else
       set -x
       git clone git@bitbucket.org:cenx-cf/$@
       set +x
    fi
}


function git_create_branch() {
    if [ -z "$1" ] ; then
        echo "*******************************************"
        echo "*   !!! WARNING !!!  Branch not created   *"
        echo "*******************************************"
        echo ""
        echo "Silly me!!! I need to specify a parameter, the branch.."
    else
        current_branch=$(parse_git_branch)
        set -x
        git checkout -b $1
        if [ $? -eq 0 ] ; then
            git push --set-upstream origin $1
            if [ $? -ne 0 ] ; then
                git checkout ${current_branch}
                git branch -D $1
            fi
        fi
        set +x
    fi
}

function exit() {
    read -t5 -n1 -p "Do you really wish to exit? [Y/n] " should_exit || should_exit=y
    case $should_exit in
        [Yy] ) builtin exit $@ ;;
        "" ) builtin exit $@ ;;
        * ) printf "\n" ;;
    esac
}

# Reference: https://github.com/chubin/wttr.in
function wttr()
{
    # change Ottawa to your default location
    local request="wttr.in/${1-Ottawa}"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

