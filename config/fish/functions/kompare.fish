function kompare
    set -l file1 $argv[1]
    set -l file2 $argv[2]

    cat $file1 | yq -r '(.kind + ":" + .metadata.namespace + ":" + .metadata.name)' | sort > /tmp/file1.txt
    cat $file2 | yq -r '(.kind + ":" + .metadata.namespace + ":" + .metadata.name)' | sort > /tmp/file2.txt

    colordiff /tmp/file1.txt /tmp/file2.txt
end
