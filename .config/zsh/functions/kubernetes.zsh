#!/bin/bash

function kubectl() {
  local cmd="kubectl"
  local extra_args

  #[ -n "$(echo "$@" | grep -e ' -f ' -e ' -k ')" ] && extra_args="--server-side"
  type kubecolor &>/dev/null && cmd="kubecolor"

  command $cmd "$@" $extra_args
}

function kvalidator() {
  echo "***** KUBE-SCORE *****"

  kustomize build . --enable-helm | kube-score score \
    --kubernetes-version "v1.26" \
    --ignore-container-cpu-limit \
    --ignore-container-memory-limit \
    --ignore-test "pod-networkpolicy" \
    --ignore-test "container-ephemeral-storage-request-and-limit" \
    -

  echo "***** KUBEVAL *****"
  kustomize build . --enable-helm | kubeval --ignore-missing-schemas --strict || return 0
}

function kustomize_menu {
  local entry=$(find . -path "*/overlays/*" -type f -name kustomization.yaml | xargs -I@ dirname @ | fzf)
  [ -z "$entry" ] && return 0

  print -z kubectl --context $(basename $entry) apply --server-side --force-conflicts -k ${entry}
}

function kompare() {
  local file1="$1"
  local file2="$2"

  cat $file1 | yq -r '(.kind + ":" + .metadata.namespace + ":" + .metadata.name)' | sort > /tmp/file1.txt
  cat $file2 | yq -r '(.kind + ":" + .metadata.namespace + ":" + .metadata.name)' | sort > /tmp/file2.txt

  colordiff /tmp/file1.txt /tmp/file2.txt
}

function kubernetes-clean-terminated-pods() {
  local context="$1"
  local namespace
  local pod

  [ -z "$context" ] && echo "$0 <context>" && return -1

  for i in $(kubectl --context ${context} get pods -A | grep 'Terminating' | awk '{print $1 ":" $2}'); do
    pod=$(echo $i | cut -d":" -f2)
    namespace=$(echo $i | cut -d":" -f1)
    kubectl --context ${context} -n ${namespace} delete pod --force --grace-period=0 ${pod}
  done

}



function kubectl-get-all {
  local context="${1}"
  local namespace="${2}"

  for i in $(kubectl --context=${context} api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    echo
    kubectl --context=${context} -n ${namespace} get --ignore-not-found ${i}
    echo ---
  done

}

function kubectl-shell-menu() {
  local context="$1"
  local instance pod namespace
  local datafile=$(mktemp)

  [ -z "$context" ] && echo "kubectl-shell-menu <context>" && return -1

  kubectl --context $context get pods -A -o template --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

  instance=$(cat $datafile | column -s ';' -t | fzf)
  [ -z "$instance" ] && return 0

  pod=$(echo "$instance" | awk '{print $1 }')
  namespace=$(echo "$instance" | awk '{print $2 }')

  #kubectl --context $context -n $namespace exec -it $pod -- sh -c "(bash || ash || sh)"
  print -z kubectl --context $context -n $namespace exec -it $pod -- sh -c "'(bash || ash || sh)'"
}

function kubectl-log-menu() {
  local context="$1"
  local instance pod namespace
  local datafile=$(mktemp)

  [ -z "$context" ] && echo "kubectl-shell-menu <context>" && return -1

  kubectl --context $context get pods -A -o template --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

  instance=$(cat $datafile | column -s ';' -t | fzf)
  [ -z "$instance" ] && return 0

  pod=$(echo "$instance" | awk '{print $1 }')
  namespace=$(echo "$instance" | awk '{print $2 }')
  #regex="$(echo $pod | sed 's/-[a-z0-9]\+$//g')-"
  regex="$(echo $pod | sed 's/-[a-z0-9]\+-[a-z0-9]\+$//g')-"

  if type stern &>/dev/null; then
    print -z stern --context ${context} -n ${namespace} ${regex}
    #stern --context ${context} -n ${namespace} ${regex}
  else
    print -z kubectl --context $context -n $namespace logs -f pod/$pod
    #kubectl --context $context -n $namespace logs -f pod/$pod
  fi
}

# alias df=kubectl-menu port-forward pods
function kubectl-menu() {
  local verb="$1"
  local objects="$2"
  local context="$3"
  local datafile=$(mktemp)
  local instance object namespace

  [ -z "$context" ] && echo "kubectl-menu <context> <verb> <objects>" && return -1

  kubectl --context $context get ${objects} -A -o template --template='{{range .items}}{{.metadata.name}}{{";"}}{{.metadata.namespace}}{{"\n"}}{{end}}' > $datafile

  instance=$(cat $datafile | column -s ';' -t | fzf)
  [ -z "$instance" ] && return 0

  object=$(echo "$instance" | awk '{print $1 }')
  namespace=$(echo "$instance" | awk '{print $2 }')

  print -z "kubectl --context ${context} -n ${namespace} ${verb} ${objects}/${object}"
}

function kubectl-pod() {
  local context="$1"
  local image="${2:-ubuntu:latest}"

  [ -z "$context" ] && echo "kubectl-pod <context> <image:default=ubuntu:latest>" && return -1

  kubectl --context ${context} run pod-${USER}-$(echo $RANDOM | md5sum | head -c 10) -it --rm --image=${image} --restart=Never -- sh -c "clear; (bash || ash || sh)"
}

function eks-volume-delete() {
  local context="$1"
  local temp=$(mktemp)
  local template='{{ range .items }}{{ .status.phase }} {{ .metadata.name }} {{ .spec.claimRef.name }} {{ .spec.csi.driver }} {{ .spec.csi.volumeHandle }}{{ "\n" }}{{ end }}'

  [ -z "$context" ] && echo "kubectl-menu <context> <verb> <objects>" && return -1

  #kubectl --context ${context} get pv | grep -i Released > $temp
  kubectl --context ${context} get pv -o template --template="$template" | grep -i '^Released' | column -t > $temp

  local pvo=$(cat $temp | fzf)
  local pv="$(echo $pvo | awk '{print $2}')"
  local fs="$(echo $pvo | awk '{print $5}' | grep -o 'fs-[a-z0-9]*')"
  local ap="$(echo $pvo | awk '{print $5}' | grep -o 'fsap-.*$')"

  [ -z "$pv" ] && return 0
  [ -z "$fs" ] && return 0

  echo "Filesystem: ${fs}"
  echo "Deleting volume pv: $pv"
  echo "Deleting access point: $ap"
  echo

  kubectl --context ${context} delete pv ${pv}
  aws efs delete-access-point --access-point-id ${ap} --profile ${context}

  # Erase filesystem
  local podname="volume-delete"
  local override="{\"spec\":{\"containers\":[{\"name\": \"${podname}\", \"volumeMounts\":[{\"name\":\"storage\",\"mountPath\":\"/data\"}]}],\"volumes\":[{\"name\":\"storage\",\"nfs\":{\"server\":\"${fs}.efs.eu-south-2.amazonaws.com\",\"path\":\"/\"}}]}}"

  kubectl --context ${context} run ${podname} -i --rm --image=ubuntu --restart=Never --override-type=strategic --overrides="${override}" -- bash -c "ls -lh /data/${pv}/ ; while [ -d '/data/${pv}' ]; do rm -I -r /data/${pv}/; done"
}


