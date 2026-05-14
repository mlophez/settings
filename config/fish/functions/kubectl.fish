function kubectl
    set -l cmd kubectl
    type -q kubecolor && set cmd kubecolor
    command $cmd $argv
end
