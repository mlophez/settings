function kubectl-log-menu
    set -l context $argv[1]
    test -z "$context"; and echo "kubectl-log-menu <context>"; and return 1

    set -l datafile (mktemp)
    kubectl --context $context get pods -A -o template \
        --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

    set -l instance (cat $datafile | column -s ';' -t | fzf)
    test -z "$instance"; and return 0

    set -l pod (echo $instance | awk '{print $1}')
    set -l namespace (echo $instance | awk '{print $2}')
    set -l regex (echo $pod | sed 's/-[a-z0-9]\+-[a-z0-9]\+$//g')-

    if type -q stern
        commandline -r "stern --context $context -n $namespace $regex"
    else
        commandline -r "kubectl --context $context -n $namespace logs -f pod/$pod"
    end
end
