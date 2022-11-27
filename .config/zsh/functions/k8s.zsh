#!/usr/bin/zsh

alias kubectl="command kubecolor"
alias ku="kubectl"
alias k="kubectl"
alias apply="kubectl apply -f"
alias delete="kubectl delete -f"

function kinfo() {
    local namespace="$1"
    clear

    if [ -z "$namespace" ]; then
        kubectl get all -o wide
        echo
        kubectl get ing -o wide
    else
        kubectl -n $namespace get all -o wide
        echo
        kubectl -n $namespace get ing -o wide
    fi
}
