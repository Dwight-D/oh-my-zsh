function dev() {
    bin=$(find . -name dev.sh)
    if [ $(echo $bin | wc -l)  -gt 1 ]; then
        echo 'Ambiguous command, multiple dev.sh found'
        echo "$(bin)"
        return
    fi
    if [ -x "$bin" ]; then
        cd $(dirname $bin) &>/dev/null && ./$(basename $bin) $@;
        cd - &>/dev/null
    else
        echo "dev.sh not found or not executable: $bin"
    fi
}

function notes(){
    branch=$(get_git_branch_ticket_name)
    dirname=$NOTES_DIR/tickets/$branch
    if [ -z $branch ]; then
        echo "Branch name not found, something went wrong"
        return
    fi
    if [ $branch = master ]; then
        echo "You're on master..."
        return
    fi
    if [ ! -d $dirname ]; then
        mkdir -p $dirname
    fi
    cd $dirname
}