function uaa-token() {
    if [ -z "$1" ]; then
        user=admin
    else
        user="$1"
    fi
    if [ -z "$2" ]; then
        password="$user"
    else
        password="$2"
    fi
    curl -s -X POST --data \
    "username=$user&password=$password&grant_type=password&scope=openid" \
    http://web_app:changeit@localhost:9999/oauth/token | jq -r ".access_token"
}
function auth() {
    if [ -z "$1" ]; then
        user=admin
    else
        user="$1"
    fi
    if [ -z "$2" ]; then
        password="$user"
    else
        password="$2"
    fi

    echo Authorization: Bearer $(uaa-token $user $password)
}

function varprompt(){
    REPLY=""
    vared -p "$1" REPLY
}

function git (){
    local gitbin=/usr/bin/git
    local FE_DIR=$CODE_DIR/portal-fe
    declare -a BACKENDS=( "portal" "message-search" "account-search" "boss-be" "uaa" "international" )
    if [ "$1" = "checkout" ]; then
        $gitbin $@
        case $PWD in
            *message-search)
                ;&
            *account-search)
                ;&
            *boss-be)
                ;&
            *uaa)
                ;&
            *international)
                vared -p "Also checkout front-end?" -c REPLY
                if [[ $REPLY =~ ^[Yy] ]]; then
                    cd $FE_DIR &>/dev/null && $gitbin $@
                    cd - &>/dev/null
                fi
                ;;
            *portal-fe)
                vared -p "Also checkout back-end? Y/n: " -c BACKEND_CHECKOUT
                if [[ $BACKEND_CHECKOUT =~ ^[Yy] ]]; then
                    arraylength=${#BACKENDS[@]}
                    for (( i=1; i<${arraylength}+1; i++ )); do
                        echo $i. ${BACKENDS[$i]}
                    done
                    vared -p "Select option: " -c BACKEND_OPT
                    backend=${BACKENDS[$BACKEND_OPT]}
                    cd $CODE_DIR/$backend &>/dev/null && $gitbin $@
                    cd - &>/dev/null
                fi
                ;;
            *)
                $gitbin $@
                ;;
        esac
    else
        $gitbin $@
    fi
}

function devup (){
    local docker_dir=~/code/portal/src/main/docker
    local front_end_dir=~/code/portal-fe
    if [ -z $1 ]; then
        devup docker server
    fi
    while [ ! -z "$1" ]; do
        case $1 in
            docker)
                cd $docker_dir &>/dev/null && docker-compose up -d gateway-app boss-be-app
                cd - &>/dev/null
                ;;
            server)
                cd $front_end_dir &>/dev/null && yarn start
                cd - &>/dev/null
                ;;
            mock)
                cd $front_end_dir &>/dev/null && yarn devMocked
                cd - &>/dev/null
                ;;
            cy)
                cd $front_end_dir &>/dev/null && yarn cy:open
                cd - &>/dev/null
                ;;
            *)
                cd $docker_dir &>/dev/null && docker-compose up -d $1
                cd - &>/dev/null
                ;;
        esac
        shift
    done
}

function syncup () {

    case "$1" in
        uaa)
            curl -X POST http://localhost:8080/api/uaasync/api/account/sync/all -H "$(auth)"
            curl -X POST http://localhost:8080/api/uaasync/api/account/sync/fullAccess/all -H "$(auth)"
            ;;
        *)
            return
            ;;
    esac
}
function amsgsearch (){
    local before_date=$(gdate +%FT%R:%S --date "1 month ago")
    local now_date=$(gdate +%FT%R:%S)
    local terms=""
    for term in $@; do
        terms+=\"$term\"
    done
    terms=$(sed 's|""|", "|g' <<<$terms)

     curl -X POST http://localhost:9024/api/message/search --data "
     {
       \"fromDate\": \"$before_date\",
       \"limit\": 0,
       \"countriesAlphaCode\": [],
       \"operatorsId\": [
       ],
       \"terms\": [$terms],
       \"toDate\": \"$now_date\"
     }
     " -v -H 'Content-Type: application/json' -H "$(auth)"
}    

function msgsearch (){
    local before_date=$(gdate +%FT%R:%S --date "1 month ago")
    local now_date=$(gdate +%FT%R:%S)
    local terms=""
    for term in $@; do
        terms+=\"$term\"
    done
    terms=$(sed 's|""|", "|g' <<<$terms)

     curl -X POST http://localhost:9024/api/message/search --data "
     {
       \"fromDate\": \"$before_date\",
       \"limit\": 0,
       \"countriesAlphaCode\": [],
       \"operatorsId\": [
       ],
       \"terms\": [$terms],
       \"toDate\": \"$now_date\"
     }
     " -v -H 'Content-Type: application/json' -H "$(auth user user)"
}    

function cconf() {
    find . -wholename "*src*bootstrap.yml" -exec yq w -i {} spring.cloud.consul.config.enabled $1 \;
}
