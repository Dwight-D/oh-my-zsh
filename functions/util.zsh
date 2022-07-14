binlink() {
    target=$1
    local full_path=$(readlink -f $1)
    if [ $? != 0 ]; then
        echo "Failed to find target"
        return 1
    fi
    ln -sv $full_path $HOME/bin/
}

soundup() {
    systemctl --user restart wireplumber pipewire pipewire-pulse
}
