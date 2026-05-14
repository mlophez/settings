function kubectl-shell-menu
    set -l context $argv[1]
    test -z "$context"; and echo "kubectl-shell-menu <context>"; and return 1

    set -l datafile (mktemp)
    kubectl --context $context get pods -A -o template \
        --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

    set -l instance (cat $datafile | column -s ';' -t | fzf)
    test -z "$instance"; and return 0

    set -l pod (echo $instance | awk '{print $1}')
    set -l namespace (echo $instance | awk '{print $2}')

    commandline -r "kubectl --context $context -n $namespace exec -it $pod -- sh -c '(bash || ash || sh)'"
end
