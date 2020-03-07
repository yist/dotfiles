#!/usr/bin/env bash

## Uncomment to disable git info
#POWERLINE_GIT=0
#
# ◣◣
# ◤◤ 
__powerline() {
    # Colorscheme
    RESET='\[\033[m\]'
    REVERSE_TEXT='\[\e[7m\]'
    #COLOR_CWD='\[\033[0;97;45m\]' # white on magenta
    COLOR_CWD='\[\033[48;5;53m\]' # purple bg
    COLOR_CWD_SUFFIX='\[\033[38;5;53m\]' # purple
    COLOR_GIT='\[\033[0;36m\]' # cyan
    COLOR_SUCCESS='\[\033[0;32m\]' # green
    COLOR_FAILURE='\[\033[0;31m\]' # red
    COLOR_DIM='\[\033[38;5;236m\]' # gray
    COLOR_MW='\[\033[38;5;54m\]' # purple

    SYMBOL_GIT_BRANCH='⑂'
    SYMBOL_GIT_MODIFIED='*'
    SYMBOL_GIT_PUSH='↑'
    SYMBOL_GIT_PULL='↓'
    SYMBOL_HLINE='┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈'

    SYMBOL_MW_UPPER='◣◣'
    SYMBOL_MW_LOWER='◤◤'

    if [[ -z "$PS_SYMBOL" ]]; then
      case "$(uname)" in
          Darwin)   PS_SYMBOL='';;
          Linux)    PS_SYMBOL='$';;
          *)        PS_SYMBOL='%';;
      esac
    fi

    __git_info() { 
        [[ $POWERLINE_GIT = 0 ]] && return # disabled
        hash git 2>/dev/null || return # git not found
        local git_eng="env LANG=C git"   # force git output in English to make our work easier

        # get current branch name
        local ref=$($git_eng symbolic-ref --short HEAD 2>/dev/null)

        if [[ -n "$ref" ]]; then
            # prepend branch symbol
            ref=$SYMBOL_GIT_BRANCH$ref
        else
            # get tag name or short unique hash
            ref=$($git_eng describe --tags --always 2>/dev/null)
        fi

        [[ -n "$ref" ]] || return  # not a git repo

        local marks

        # scan first two lines of output from `git status`
        while IFS= read -r line; do
            if [[ $line =~ ^## ]]; then # header line
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
            else # branch is modified if output contains more lines after the header line
                marks="$SYMBOL_GIT_MODIFIED$marks"
                break
            fi
        done < <($git_eng status --porcelain --branch 2>/dev/null)  # note the space between the two <

        # print the git branch segment without a trailing newline
        printf "$ref$marks"
    }

    set_virtualenv() {
      if test -z "$VIRTUAL_ENV" ; then
          PYTHON_VIRTUALENV=""
      else
          PYTHON_VIRTUALENV="${COLOR_BLUE}(`basename \"$VIRTUAL_ENV\"`)${COLOR_NC} "
      fi
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            local symbol="${COLOR_SUCCESS}${PS_SYMBOL}${RESET}"
        else
            local symbol="${COLOR_FAILURE}${PS_SYMBOL}${RESET}"
        fi

        #local RARROW="❥" # ┋
        local RARROW=""

        local cwd="${COLOR_CWD}\w "
        # Bash by default expands the content of PS1 unless promptvars is disabled.
        # We must use another layer of reference to prevent expanding any user
        # provided strings, which would cause security issues.
        # POC: https://github.com/njhartwell/pw3nage
        # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
        if shopt -q promptvars; then
            __powerline_git_info="$(__git_info)"
            local git="${REVERSE_TEXT} ${__powerline_git_info} "
        else
            # promptvars is disabled. Avoid creating unnecessary env var.
            local git="${REVERSE_TEXT} $(__git_info) "
        fi

        if test -z "$VIRTUAL_ENV" ; then
            local pyvenv="${RESET}${COLOR_CWD} venv:off "
        else
            #local pyvenv="${REVERSE_TEXT}venv:`basename \"$VIRTUAL_ENV\"`${RESET}▶"
            local pyvenv="${RESET}${COLOR_CWD} venv:`basename \"$VIRTUAL_ENV\"` "
        fi
	local tm="${REVERSE_TEXT} \t ${RESET}"
	local mwu="${COLOR_MW}${SYMBOL_MW_UPPER}${RESET}"
	local mwl="${COLOR_MW}${SYMBOL_MW_LOWER}${RESET}"
	#local div="${COLOR_DIM}${SYMBOL_HLINE}${RESET}"

        #PS1="${div}\n${mwu}${cwd}$symbol ${git}$symbol ${pyvenv}$symbol ${tm}\n${mwl}"
	PS1="${mwu}${cwd}${git}${pyvenv}${tm}\n${mwl}"
    }

    PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

__powerline
unset __powerline
