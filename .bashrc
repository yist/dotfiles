export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH=$HOME/bin:$PATH
export EDITOR="vim"

export LD_LIBRARY_PATH=/usr/local/lib

TERM=xterm-256color

#-------------------------------------------------------------
# Colors
#-------------------------------------------------------------
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------

alias ls='ls -GFh'
alias ll="ls -lv"
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

host_name=`hostname`
if [ "$host_name" = "ubuntu-trusty-1" ]
then
  alias vim="$HOME/usr/local/bin/vim"
else
  alias vim="/usr/bin/vim"
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# The next line updates PATH for the Google Cloud SDK.
#source '/home/yi_liu/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
#source '/home/yi_liu/google-cloud-sdk/completion.bash.inc'

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

gitbranch() {
    export GITBRANCH=""

    local repo="${_GITBRANCH_LAST_REPO-}"
    local gitdir=""
    [[ ! -z "$repo" ]] && gitdir="$repo/.git"

    # If we don't have a last seen git repo, or we are in a different directory
    if [[ -z "$repo" || "$PWD" != "$repo"* || ! -e "$gitdir" ]]; then
        local cur="$PWD"
        while [[ ! -z "$cur" ]]; do
            if [[ -e "$cur/.git" ]]; then
                repo="$cur"
                gitdir="$cur/.git"
                break
            fi
            cur="${cur%/*}"
        done
    fi

    if [[ -z "$gitdir" ]]; then
        unset _GITBRANCH_LAST_REPO
        return 0
    fi
    export _GITBRANCH_LAST_REPO="${repo}"
    local head=""
    local branch=""
    read head < "$gitdir/HEAD"
    case "$head" in
        ref:*)
            branch="${head##*/}"
            ;;
        "")
            branch=""
            ;;
        *)
            branch="d:${head:0:7}"
            ;;
    esac
    if [[ -z "$branch" ]]; then
        return 0
    fi
    echo "$branch"
}

function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv) "
}

# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

VENV="\$(virtualenv_info)"
#GIT_BRANCH_NAME="\$(parse_git_branch)"
GIT_BRANCH_NAME="\$(gitbranch)"

export PS1="\n\[${COLOR_RED}\]${VENV}"
export PS1=$PS1"\n\[${COLOR_BROWN}\]\u\[${COLOR_LIGHT_GRAY}\]@\[${COLOR_LIGHT_GREEN}\]\h\[${COLOR_LIGHT_GRAY}\]:"
export PS1=$PS1"\[${COLOR_BLUE}\]\w \[${COLOR_PURPLE}\]\e[7m${GIT_BRANCH_NAME}\e[27m\n\[${COLOR_LIGHT_CYAN}\]\$ \[${COLOR_NC}\]"

if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

