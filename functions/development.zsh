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

function routing() {
    local all_apps=("daisy" "peach" "smsc-db-adapter" "bff" "event-adapter" "kitana")
    local routing_dir=$HOME/code/routing
    cmd=$1
    if [[ -z $cmd ]]; then
        echo No command provided
        return 1
    fi
    shift
    case $cmd in
        dev)
            echo Running routing environment
            no_run_app=$1
            startdir=$PWD
            for app in $all_apps; do
                if [[ "$app" != "$no_run_app" ]]; then
                    echo "Running $app"
                    cd $routing_dir/$app &>/dev/null
                    ./dev.sh run
                fi
            done
            cd $startdir &>/dev/null
            return 0
            ;;
        *)
            echo Unrecognized command: $cmd
            return 1
            ;;
    esac
}
