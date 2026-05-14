function aws-inventory
    set -l regions eu-west-1 eu-south-2
    set -l profiles ireland production tools demo qa dev shared mutua secure backoffice
    set -l query '.Reservations[]
    | .Instances[]
    | select(.State.Name != "terminated")
    | {
        Name: (.Tags[] | select(.Key=="Name") | .Value),
        InstanceId: .InstanceId,
        PrivateIP: .PrivateIpAddress,
        PublicIP: (.PublicIpAddress // "N/A"),
        Region: $region,
        Profile: $profile
      }
    | join(";")'

    mkdir -p $HOME/.aws
    printf '' > $HOME/.aws/inventory

    for profile in $profiles
        echo "[+] Profile: $profile"
        for region in $regions
            aws ec2 describe-instances --region $region --profile $profile | \
                jq --arg region "$region" --arg profile "$profile" -r "$query" >> $HOME/.aws/inventory
        end
    end
end
