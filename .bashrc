export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export PATH=/usr/local/bin:$HOME/bin:$HOME/google-cloud-sdk/bin:$HOME/go/bin:/usr/local/go/bin:/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH
export EDITOR="vim"
export LD_LIBRARY_PATH=/usr/local/lib
export TERM=xterm-256color

host_name=`hostname`

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  source $HOME/.linux.bash
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='mac'
  source $HOME/.mac.bash
fi
echo "Platform: $platform"

alias ll='ls -lG'
alias la='ls -lGAf'
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

export PIP_REQUIRE_VIRTUALENV=false
gpip() {
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}


if [ -f $HOME/bin/bazel-complete.bash ]; then
  source $HOME/bin/bazel-complete.bash
fi

if [ -f $HOME/.pyenvs/python3/bin/activate ]; then
  alias py365="source $HOME/.pyenvs/python3/bin/activate"
fi


#if [ -f ~/.prompt.bash ]; then
#  source ~/.prompt.bash
#fi
[ -f ~/.bash-powerline.sh ] && source ~/.bash-powerline.sh

if [ -f ~/.fzf_config.bash ]; then
  source ~/.fzf_config.bash
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1

# Pyenv
#eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
