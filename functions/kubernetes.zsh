function kimg {
    kubectl describe deployment $1 | grep Image | squt 2 | cut -d : -f 3
} 