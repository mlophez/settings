function terraform-modulizer
    set -l module_path $argv[1]
    set -l module_name $argv[2]

    cat $module_path/*.tf | grep 'resource "' | cut -d' ' -f2,3 \
        | sed 's/" "/./g' | tr -d '"' \
        | xargs -I@ echo terraform state mv @ module.$module_name.@
end
