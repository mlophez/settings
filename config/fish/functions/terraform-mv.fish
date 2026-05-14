function terraform-mv
    set -l from_module $argv[1]
    set -l to_module $argv[2]
    set -l resources $argv[3]

    test "$from_module" != root; and set from_module "module.$from_module."; or set from_module ""
    test "$to_module" != root; and set to_module "module.$to_module."; or set to_module ""
    test -d "$resources"; and set resources "$resources/*.tf"

    eval "cat $resources" | grep -v '^ *#' | grep 'resource "' | cut -d' ' -f2,3 \
        | sed 's/" "/./g' | tr -d '"' \
        | xargs -I@ echo terraform state mv $from_module@ $to_module@
end
