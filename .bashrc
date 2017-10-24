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

alias ll='ls -lG'
alias la='ls -lGAf'
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...


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



#-------------------------------------------------------------
# Colors
#-------------------------------------------------------------
export COLOR_NC='\[\e[0;39m\]' # No Color
export COLOR_WHITE='\[\e[1;37m\]'
export COLOR_BLACK='\[\e[0;30m\]'
export COLOR_BLUE='\[\e[0;34m\]'
export COLOR_LIGHT_BLUE='\[\e[1;34m\]'
export COLOR_GREEN='\[\e[0;32m\]'
export COLOR_LIGHT_GREEN='\[\e[1;32m\]'
export COLOR_CYAN='\[\e[0;36m\]'
export COLOR_LIGHT_CYAN='\[\e[1;36m\]'
export COLOR_RED='\[\e[0;31m\]'
export COLOR_LIGHT_RED='\[\e[1;31m\]'
export COLOR_PURPLE='\[\e[0;35m\]'
export COLOR_LIGHT_PURPLE='\[\e[1;35m\]'
export COLOR_BROWN='\[\e[0;33m\]'
export COLOR_YELLOW='\[\e[1;33m\]'
export COLOR_GRAY='\[\e[0;30m\]'
export COLOR_LIGHT_GRAY='\[\e[0;37m\]'
export REVERSE_TEXT='\[\e[7m\]'
export REVERSE_RESET='\[\e[27m\]'
export UNDERLINE_TEXT='\[\e[4m\]'
export UNDERLINE_RESET='\[\e[24m\]'

# Determine active Python virtualenv details.
function set_virtualenv() {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${COLOR_BLUE}(`basename \"$VIRTUAL_ENV\"`)${COLOR_NC} "
  fi
}

function rightprompt() {
  RIGHT_PROMPT="${TIMESTAMP}"
  printf "%*s" $COLUMNS "$RIGHT_PROMPT"
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${COLOR_LIGHT_RED}\$${COLOR_NC}"
  fi
}

function set_timestamp() {
  TIMESTAMP=`date +%Y/%m/%d-%H:%M:%S`
}


function set_bash_prompt() {
  set_prompt_symbol $?
  set_virtualenv
  set_timestamp

  PS1="
${UNDERLINE_TEXT}\[$(tput sc; rightprompt; tput rc)\]${UNDERLINE_RESET}${COLOR_GREEN}\u@\h ${COLOR_LIGHT_PURPLE}\w${COLOR_NC} ${PYTHON_VIRTUALENV}
${PROMPT_SYMBOL} "
}

PROMPT_COMMAND=set_bash_prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1
export FZF_COMPLETION_TRIGGER='..'
export FZF_COMPLETION_OPTS='+c -x'



# FZF tmux switch session
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
     tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
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

export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--height 30% --reverse --border'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

