#Read markdown in cli browser
rmd () {
  pandoc $1 | lynx -stdin
}

hack() {
    while true; do
        clear
        echo Hacking $1, please wait...
        echo -n "Progress: "
        for i in {1..10}; do
            echo -n .
            sleep 1;
        done
    done;
}
