function kubectl-run-pod
    set -l context $argv[1]
    set -l image $argv[2]
    test -z "$image"; and set image ubuntu:latest
    test -z "$context"; and echo "kubectl-run-pod <context> [image:default=ubuntu:latest]"; and return 1

    set -l username (string replace -a '.' '' $USER)
    set -l suffix (echo $RANDOM | md5sum | head -c 10)

    kubectl --context $context run pod-$username-$suffix -it --rm --image=$image --restart=Never -- sh -c 'clear; (bash || ash || sh)'
end
