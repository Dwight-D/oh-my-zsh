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
