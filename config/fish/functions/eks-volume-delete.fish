function eks-volume-delete
    set -l context $argv[1]
    test -z "$context"; and echo "eks-volume-delete <context>"; and return 1

    set -l template '{{ range .items }}{{ .status.phase }} {{ .metadata.name }} {{ .spec.claimRef.name }} {{ .spec.csi.driver }} {{ .spec.csi.volumeHandle }}{{ "\n" }}{{ end }}'
    set -l temp (mktemp)

    kubectl --context $context get pv -o template --template="$template" | grep -i '^Released' | column -t > $temp

    set -l pvo (cat $temp | fzf)
    set -l pv (echo $pvo | awk '{print $2}')
    set -l fs (echo $pvo | awk '{print $5}' | grep -o 'fs-[a-z0-9]*')
    set -l ap (echo $pvo | awk '{print $5}' | grep -o 'fsap-.*$')

    test -z "$pv"; and return 0
    test -z "$fs"; and return 0

    echo "Filesystem: $fs"
    echo "Deleting volume pv: $pv"
    echo "Deleting access point: $ap"
    echo

    kubectl --context $context delete pv $pv
    aws efs delete-access-point --access-point-id $ap --profile $context

    set -l podname volume-delete
    set -l override "{\"spec\":{\"containers\":[{\"name\": \"$podname\", \"volumeMounts\":[{\"name\":\"storage\",\"mountPath\":\"/data\"}]}],\"volumes\":[{\"name\":\"storage\",\"nfs\":{\"server\":\"$fs.efs.eu-south-2.amazonaws.com\",\"path\":\"/\"}}]}}"

    kubectl --context $context run $podname -i --rm --image=ubuntu --restart=Never --override-type=strategic --overrides="$override" -- bash -c "ls -lh /data/$pv/ ; while [ -d '/data/$pv' ]; do rm -I -r /data/$pv/; done"
end
