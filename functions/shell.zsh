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

#cd to dir and ls contents
function cd() {
    if [ -z "$*" ]; then
        destination=~
    else
        destination=$*
    fi
    builtin cd "${destination}" >/dev/null && ls
}

function mkalias(){
    if [ $# -lt 2 ]; then
        echo 'Usage: mkalias alias command'
        return 1
    fi
    name=$1
    shift
    echo "alias $name='$@'" >> $ZSH/custom/aliases.zsh
}