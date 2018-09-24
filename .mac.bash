alias vim="/usr/local/bin/vim"
alias mvim="/usr/local/bin/mvim"

alias vi='mvim -v'
alias vim='mvim -v'
export EDITOR="mvim -v"

export DISABLE_AUTO_TITLE="true"
tt () {
  echo -e "\033];$@\007"
}

export HOMEBREW_NO_ANALYTICS=1

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"