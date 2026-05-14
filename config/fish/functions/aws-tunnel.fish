function aws-tunnel
    set -l target $argv[1]
    set -l instance $argv[2]
    set -l profile $argv[3]

    set -l lport (echo $target | cut -d: -f1)
    set -l host (echo $target | cut -d: -f2)
    set -l port (echo $target | cut -d: -f3)

    aws ssm start-session --cli-read-timeout 80000 --target $instance \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "{\"host\":[\"$host\"],\"portNumber\":[\"$port\"],\"localPortNumber\":[\"$lport\"]}" \
        --profile $profile
end
