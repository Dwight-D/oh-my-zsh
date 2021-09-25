function kimg {
    kubectl describe deployment $1 | grep Image | grep nexus.int.clxnetworks |  squt 2 | cut -d : -f 3
} 
