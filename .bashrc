export PS1='\n\[\033[1;33m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h\[\033[1;37m\]:\[\033[1;31m\]\w\n\[\033[1;36m\]\$ \[\033[0m\]'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH=$HOME/bin:$PATH
export EDITOR="vim"

export LD_LIBRARY_PATH=/usr/local/lib

TERM=xterm-256color

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------

alias ls='ls -GFh'
alias ll="ls -lv"
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

alias vim="/usr/bin/vim"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# The next line updates PATH for the Google Cloud SDK.
#source '/home/yi_liu/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
#source '/home/yi_liu/google-cloud-sdk/completion.bash.inc'

if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

