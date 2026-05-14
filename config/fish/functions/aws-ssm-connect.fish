function aws-ssm-connect
    set -l instance (cat $HOME/.aws/inventory | column -s ';' -t | fzf)
    test -z "$instance"; and return 0

    echo $instance | awk '{ print $1 }'

    set -l instance_name (echo $instance | awk '{print $1}')
    set -l instance_id (echo $instance | awk '{print $2}')
    set -l region (echo $instance | awk '{print $5}')
    set -l profile (echo $instance | awk '{print $6}')

    echo "-> Connect to $instance_id - $instance_name"
    echo "aws ssm start-session --target $instance_id --region $region --profile $profile --cli-read-timeout 8000"

    if test -n "$argv[1]"
        ssh $instance_id -o "ProxyCommand=aws ssm start-session --target $instance_id --document-name AWS-StartSSHSession --parameters 'portNumber=22' --region $region --profile $profile"
    else
        aws ssm start-session --target $instance_id --region $region --profile $profile
    end
end
