# ____             _             
#|  _ \  ___   ___| | _____ _ __ 
#| | | |/ _ \ / __| |/ / _ \ '__|
#| |_| | (_) | (__|   <  __/ |   
#|____/ \___/ \___|_|\_\___|_|

function dr() {
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
