export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h: \[\e[33m\]\w\[\e[0m\]\n\$ '
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH=$HOME/bin:$PATH
export EDITOR="vim"

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
source '/home/yi_liu/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/home/yi_liu/google-cloud-sdk/completion.bash.inc'
