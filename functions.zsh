#cd to dir and ls contents
function cd() {
    if [ -z "$*" ]; then
        destination=~
    else
        destination=$*
    fi
    builtin cd "${destination}" >/dev/null && ls
}

#Navigate upwards
function up() {
    counter=$1
    if [ -z $counter ]; then
        counter=1
    fi
    dest=""
    while (( $counter > 0 )); do
        dest=$dest"../"
        ((counter--))
    done;
    cd $dest
}

function tolower() {
    echo $@ | awk '{ print tolower($0) }'
}

function cpuu() {
    ps -A -o %cpu | awk '{s+=$1} END {print s}'
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
    eval "$@"
    result=$?
    #Play sound
    ping $result
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

#Read markdown in cli browser
rmd () {
  pandoc $1 | lynx -stdin
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

# ____             _             
#|  _ \  ___   ___| | _____ _ __ 
#| | | |/ _ \ / __| |/ / _ \ '__|
#| |_| | (_) | (__|   <  __/ |   
#|____/ \___/ \___|_|\_\___|_|

dr (){
    case $1 in
        kill )
            vared -p "Kill all containers?" -c REPLY
            echo
            if [[ $REPLY =~ ^[Yy] ]]; then
                docker kill $(docker ps -q)
            fi
            ;;
        rm )
            vared -p "Remove all containers?" -c REPLY
            echo
            if [[ $REPLY =~ ^[Yy] ]]; then
                docker container rm $(docker container ls -aq)
            fi
            ;;
        nuke )
            vared -p "Stopping containers, removing volumes and dangling data. Continue?" -c REPLY
            echo
            if [[ $REPLY =~ ^[Yy] ]]; then
                yes | dr kill
                yes | dr rm
                yes | docker system prune --volumes
            fi
            ;;
        rmi )
            vared -p "Remove all images?" -c REPLY
            echo
            if [[ $REPLY =~ ^[Yy] ]]; then
                docker image rm $(docker image ls -q) --force
            fi
            ;;
        rmv)
            vared -p "Remove dangling docker volumes?" -c REPLY
            echo
            if [[ $REPLY =~ ^[Yy] ]]; then
                docker volume ls -q -f dangling=true
            fi
            ;;
       build)
            components=(account-search account-search-sync international portal uaa)
            for dir in $components; do
                cd $dir && gradlew -Pdocker clean build -x test && gradlew -Pdocker buildDocker -x test; cd -
            done;
            ;;
    esac
}
