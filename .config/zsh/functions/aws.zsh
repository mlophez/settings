#!/bin/bash

alias a="aws-ssm-connect"
alias as="aws-ssm-connect ssh"
alias am="aws-profile-menu"

function aws-profile-menu() {
  local profile="$(cat $HOME/.aws/config | grep -v "^ *#" | grep -o "\[ *profile .*\]" | sed 's/\]//g' | cut -d" " -f 2 | fzf)"
  [ -z "$profile" ] && return 0
  export AWS_PROFILE="$profile"
}

function aws-inventory() {
  local regions=("eu-west-1" "eu-south-2")
  local profiles=($(cat $HOME/.aws/config | grep -v "^ *#" | grep -o "\[ *profile .*\]" | sed 's/\]//g' | cut -d" " -f 2 | grep -v root |tr "\n" ' '))
  local query='.Reservations[] | .Instances[] | select(.State.Name != "terminated") | { Name: (.Tags[]|select(.Key=="Name")|.Value), InstanceId: .InstanceId, Region: $region, Profile: $profile } | join (";") '
  local region profile

  [ ! -d "$HOME/.aws" ] && mkdir -p $HOME/.aws

  # INVENTORY FILE
  cat /dev/null > $HOME/.aws/inventory
  for profile in $profiles; do
    for region in $regions; do
      aws ec2 describe-instances --region $region --profile $profile | \
        jq --arg region "$region" --arg profile "$profile" -r "$query" >> $HOME/.aws/inventory
    done
  done
}

function aws-ssm-connect() {
  local instance
  local instance_name instance_id region profile

  instance=$(cat $HOME/.aws/inventory | column -s ';' -t | fzf )
  [ -z "$instance" ] && return 0

  echo "$instance" | awk '{ print $1 }'

  instance_name=$(echo "$instance" |  awk '{print $1 }')
  instance_id=$(echo "$instance" |  awk '{print $2 }')
  region=$(echo "$instance" |  awk '{print $3 }')
  profile=$(echo "$instance" |  awk '{print $4 }')

  echo "-> Connect to ${instance_id} - ${instance_name}"
  echo "aws ssm start-session --target ${instance_id} --region ${region} --profile ${profile}" --cli-read-timeout 8000

  if [ -z "$1" ]; then
    eval ssh ${instance_id} -o ProxyCommand=\"aws ssm start-session --target ${instance_id} \
      --document-name AWS-StartSSHSession --parameters 'portNumber=22' \
      --region ${region} --profile ${profile}\"
  else
    eval aws ssm start-session --target ${instance_id} --region ${region} --profile ${profile}
  fi

  #ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --profile logalty
  # aws ssm start-session --target "Your Instance ID" --document-name AWS-StartPortForwardingSession --parameters "portNumber"=["80"],"localPortNumber"=["56789"]
}

function aws-tunnel() { # 1521:oradb01.cmu2qzz9znmw.eu-south-2.rds.amazonaws.com:1521 i-0fcd1f120811b7f42
  local target=$1
  local instance=$2
  local profile=$3

  local lport=$(echo $target | cut -d":" -f 1)
  local host=$(echo $target | cut -d":" -f 2)
  local port=$(echo $target | cut -d":" -f 3)

  aws ssm start-session --cli-read-timeout 80000 --target ${instance} \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"${host}\"],\"portNumber\":[\"${port}\"],\"localPortNumber\":[\"${lport}\"]}" \
  --profile demo
}

