export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH=/usr/local/bin:$HOME/bin:$HOME/google-cloud-sdk/bin:$PATH
export EDITOR="vim"

export LD_LIBRARY_PATH=/usr/local/lib

TERM=xterm-256color

host_name=`hostname`

if [ "$host_name" = "ubuntu-trusty-1" ]
then
  alias vim="$HOME/usr/local/bin/vim"
else
  alias vim="/usr/bin/vim"
  alias mvim="/usr/local/Cellar/macvim/8.0-134/bin/mvim"
fi

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  echo "Platform: $platform"
  alias vi='mvim -v'
  alias vim='mvim -v'
  export EDITOR="mvim -v"
fi



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

alias lh='ls -GFh'
alias ll="ls -lv"
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...


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

function iterm2_print_user_vars() {
    iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}


# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

VENV="\$(virtualenv_info)"
#GIT_BRANCH_NAME="\$(parse_git_branch)"
#GIT_BRANCH_NAME="\$(gitbranch)"

export PS1="\n\[${COLOR_RED}\]${VENV}"
export PS1=$PS1"\n\[${COLOR_CYAN}\]\u\[${COLOR_LIGHT_GRAY}\]@\[${COLOR_LIGHT_GREEN}\]\h\[${COLOR_LIGHT_GRAY}\]:"
export PS1=$PS1"\[${COLOR_BLUE}\]\w \[${COLOR_RED}\]\n\[${COLOR_LIGHT_CYAN}\]\$ \[${COLOR_NC}\]"


export PIP_REQUIRE_VIRTUALENV=true
gpip() {
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

DISABLE_AUTO_TITLE="true"
tt () {
  echo -e "\033];$@\007"
}

if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

export HOMEBREW_NO_ANALYTICS=1

# FZF tmux switch session
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# FZF - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# FZF Git
# fbr - checkout git branch
# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

