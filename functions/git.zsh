
function git_repo_name() {
    repo=$(basename $(git rev-parse --show-toplevel))
}

function get_git_branch_ticket_name() {
    git rev-parse --abbrev-ref HEAD | sed 's|.*/||'
    #sed -E 's|.*/([a-zA-Z]*-[0-9]+).*|\1|'
}

function gmod() {
    if [ -z "$1" ]; then
        git status | grep modified | tr -s " " | cut -d " " -f 2
    else
        git status | grep modified | tr -s " " | cut -d " " -f 2 | grep -v $1
    fi
}

function gunt(){
    git status -s | grep "??" | cut -f 2 -d " "
}

function ignore(){
    if [ ! -e .git ]; then
        echo "Not a git directory, what are you doing?"
        return
    fi
    for file in "$@"; do
        echo $file >> .gitignore
    done
}