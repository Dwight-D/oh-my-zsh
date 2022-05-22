function lastcmd(){
    history | tail -n1 | tr -s ' ' | gcut -d ' ' --complement -f 1
}

function cc(){
    lastcmd | pbcopy
}

function tabname() {
    echo -ne "\033]0;"$*"\007"
}

function cpuping () {
    while (( $(cpuu) > 100)); do
    sleep 10
    done;
    afplay /System/Library/Sounds/Ping.aiff -v 10
}

function cpuu() {
    ps -A -o %cpu | awk '{s+=$1} END {print s}'
}

#Plays a sound depending on result of previous command (passed as pos arg)
_ping (){
    result=$1
    #If last command was a failure, set to fail sound
    if [ "$result" != 0 ]; then
        sound=/System/Library/Sounds/Basso.aiff    
    else
        sound=/System/Library/Sounds/Ping.aiff
    fi
    afplay "$sound" -v 4
}

#Perform pos arg as command and notifies with sound and notification when completed
#based on command result
notify (){
    #Perform argument as command
    eval "$@"
    result=$?
    #Play sound
    _ping $result
    cmd_notification $result "$@"
}

#Display a notification based on command and its result (pos args)
cmd_notification (){
    if [[ "$#" -lt 2 ]]; then
        echo "Usage: cmd_notification result command"
        return
    fi
    result=$1
    shift
    cmd=$@
    notify_text="Command completed: "
    if [[ "$result" != 0 ]]; then
        notify_text+="FAILURE - $result"
    else
        notify_text+=SUCCESS
    fi
    osascript -e "display notification \"$notify_text\" with title \"$cmd\""
}

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd "$(cat "$tempfile")"
    fi
    cat "$tempfile"
    rm -f -- "$tempfile"
}

toclip() {
    if [ -f "$1" ]; then
        cat $1 | pbcopy
    else
        echo -n "$1" | pbcopy
    fi
}
