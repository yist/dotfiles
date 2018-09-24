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