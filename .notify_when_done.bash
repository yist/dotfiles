# Copyright (c) 2008-2012 undistract-me developers. See LICENSE for details.
#
# Source this, and then run notify_when_long_running_commands_finish_install
#
# Relies on http://www.twistedmatrix.com/users/glyph/preexec.bash.txt
# Generate a notification for any command that takes longer than this amount
# of seconds to return to the shell.  e.g. if LONG_RUNNING_COMMAND_TIMEOUT=10,
# then 'sleep 11' will always generate a notification.
# Default timeout is 120 seconds.
if [ -z "$LONG_RUNNING_COMMAND_TIMEOUT" ]; then
  LONG_RUNNING_COMMAND_TIMEOUT=120
fi
# The pre-exec hook functionality is in a separate branch.
if [ -z "$LONG_RUNNING_PREEXEC_LOCATION" ]; then
  LONG_RUNNING_PREEXEC_LOCATION=/usr/share/undistract-me/preexec.bash
fi
if [ -f "$LONG_RUNNING_PREEXEC_LOCATION" ]; then
  . $LONG_RUNNING_PREEXEC_LOCATION
else
  echo "Could not find preexec.bash"
fi
if [ -z "$NOTIFYME_DIR" ]; then
  NOTIFYME_DIR="$HOME/.notifyme"
fi
if [ ! -d "$NOTIFYME_DIR" ]; then
  echo "Creating directory for notifyme: $NOTIFYME_DIR"
  mkdir -p $NOTIFYME_DIR
fi
# notify_me_by_email(<from>, <to>, <title>, <body>)
function notify_me_by_email() {
  echo "$4" | ~/bin/sendemail \
    --subject="$3" --to="$2" --from="$1"
}
function notify_when_done_install() {
  function start_monitor_proc() {
    touch $NOTIFYME_DIR/$1.txt
  }
  function end_monitor_proc() {
    rm $NOTIFYME_DIR/$1.txt
  }
  function active_window_id () {
    if [[ -n $DISPLAY ]] ; then
      set - $(xprop -root _NET_ACTIVE_WINDOW)
      echo $5
      return
    fi
    echo nowindowid
  }
  function sec_to_human () {
    local H=''
    local M=''
    local S=''
    local h=$(($1 / 3600))
    [ $h -gt 0 ] && H="${h} hour" && [ $h -gt 1 ] && H="${H}s"
    local m=$((($1 / 60) % 60))
    [ $m -gt 0 ] && M=" ${m} min" && [ $m -gt 1 ] && M="${M}s"
    local s=$(($1 % 60))
    [ $s -gt 0 ] && S=" ${s} sec" && [ $s -gt 1 ] && S="${S}s"
    echo $H$M$S
  }
  function precmd () {
    if [[ -n "$__udm_last_command_started" ]]; then
      local now current_window
      printf -v now "%(%s)T" -1
      current_window=$(active_window_id)
      if [[ $current_window != $__udm_last_window ]] ||
        [[ $current_window == "nowindowid" ]] ; then
        local time_taken=$(( $now - $__udm_last_command_started ))
        local time_taken_human=$(sec_to_human $time_taken)
        local appname=$(basename "${__udm_last_command%% *}")
        local running_host=$(hostname)
        local app_notify_file=$NOTIFYME_DIR/$__udm_last_pid.txt
        #if [[ $time_taken -gt $LONG_RUNNING_COMMAND_TIMEOUT ]] &&
        if [[ -f $app_notify_file ]] ; then
          local mail_title="[$appname] done"
          local mail_body="The following command finished in $time_taken seconds at $running_host:"$'\n'"${__udm_last_command}"
          notify_me_by_email "${USER}+notifyme" "${USER}+notifyme" "${mail_title}" "${mail_body}"
          rm $app_notify_file
        fi
      fi
    fi
  }
  function preexec () {
    # use __udm to avoid global name conflicts
    __udm_last_command_started=$(printf "%(%s)T\n" -1)
    __udm_last_command=$(echo "$1")
    __udm_last_window=$(active_window_id)
    __udm_last_pid=$$
  }
  preexec_install
}
