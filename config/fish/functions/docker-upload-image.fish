function docker-upload-image
    set -l host $argv[1]
    set -l image $argv[2]

    if test -z (docker images | sed 's/  */:/g' | grep $image)
        echo "[-] Image doesn't exist"
        return 1
    end

    docker save $image | pv | ssh -C $host docker load

    if string match -q 'localhost*' $image
        ssh $host "docker tag $image "(string replace 'localhost/' '' $image)
        ssh $host "docker image rm $image"
    end
end
