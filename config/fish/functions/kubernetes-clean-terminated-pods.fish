function kubernetes-clean-terminated-pods
    set -l context $argv[1]
    test -z "$context"; and echo "$0 <context>"; and return 1

    for i in (kubectl --context $context get pods -A | grep Terminating | awk '{print $1":"$2}')
        set -l pod (echo $i | cut -d: -f2)
        set -l namespace (echo $i | cut -d: -f1)
        kubectl --context $context -n $namespace delete pod --force --grace-period=0 $pod
    end
end
