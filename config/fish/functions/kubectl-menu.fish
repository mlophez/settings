function kubectl-menu
    set -l verb $argv[1]
    set -l objects $argv[2]
    set -l context $argv[3]
    test -z "$context"; and echo "kubectl-menu <verb> <objects> <context>"; and return 1

    set -l datafile (mktemp)
    kubectl --context $context get $objects -A -o template \
        --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

    set -l instance (cat $datafile | column -s ';' -t | fzf)
    test -z "$instance"; and return 0

    set -l object (echo $instance | awk '{print $1}')
    set -l namespace (echo $instance | awk '{print $2}')

    commandline -r "kubectl --context $context -n $namespace $verb $objects/$object"
end
