function kpod() {
    local default_ns=iptvtest3
    local target=$1
    local ns=${2:-$default_ns}
    kubectl -n $ns get pods -l app=$target --no-headers=true | grep -v "0/" | cut -d " " -f 1
}
