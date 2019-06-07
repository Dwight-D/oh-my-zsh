#cd to dir and ls contents
function cd() {
    if [ -z "$*" ]; then
        destination=~
    else
        destination=$*
    fi
    builtin cd "${destination}" >/dev/null && ls
}

#Plays a sound depending on result of previous command (passed as pos arg)
ping (){
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
    eval $@
    result=$?
    #Play sound
    ping $result
    cmd_notification "$@" $result
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

#Read markdown in cli browser
rmd () {
  pandoc $1 | lynx -stdin
}
