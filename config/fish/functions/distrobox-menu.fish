function distrobox-menu
    set -l container_name (distrobox list --no-color | awk -F'|' '{print $2}' | grep -v NAME | fzf)
    test -n "$container_name"; and distrobox enter $container_name
end
