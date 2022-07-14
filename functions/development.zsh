function token_quote {
  local quoted=()
  for token; do
    quoted+=( "$(printf '%q' "$token")" )
  done
  printf '%s\n' "${quoted[*]}"
}

function dvr() {
    image=$1
    shift
    docker run --rm -t -i -v $PWD:$PWD -w $PWD $image $@
}

function gw() {
    cmd=$(token_quote $@)
    cmd="_git $cmd"
    cmd=$(gitreplace \@gh-tv4 $cmd)
    eval $cmd
}

function gp() {
    cmd=$(token_quote $@)
    cmd="_git $cmd"
    cmd=$(gitreplace \@gh-personal $cmd)
    eval $cmd
}

#function gitreplace() {
#    remote=$1
#    shift
#    args=$@
#    cmd=$(echo $cmd | sed "s/@github.com/$remote/")
#    echo $cmd
#}

#local function _git() {
#    /usr/bin/env git $@
#}

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

function auth {
    local token_path="$1"
    if [ -z $token_path]; then
        token_path=token.hex
    fi
    local output="Authorization: Bearer $(cat $token_path)"
    echo $output
}

function extract_token {
    jq '.access_token' | tr -d '"'
}

function twrap {
    read -d '' text
    echo "$text" | sed -z 's|\n|\\n|g' | sed -E 's|^(.*)$|{ "text": "\1"}|'
}
