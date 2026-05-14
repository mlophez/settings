function kustomize-menu
    set -l entry (find . -path '*/overlays/*' -type f -name kustomization.yaml | xargs -I@ dirname @ | fzf)
    test -z "$entry"; and return 0

    set -l context (basename (echo $entry | grep -o '.*/overlays/[a-zA-Z0-9]*'))

    switch $argv[1]
        case apply
            commandline -r "kustomize build --enable-helm --load-restrictor LoadRestrictionsNone $entry | kubectl --context $context apply --server-side --force-conflicts -f -"
        case diff
            commandline -r "kustomize build --enable-helm --load-restrictor LoadRestrictionsNone $entry | kubectl --context $context diff --server-side --force-conflicts -f -"
        case bundle
            commandline -r "kustomize build --enable-helm --load-restrictor LoadRestrictionsNone $entry | tee $entry/bundle.yaml"
    end
end
