function workspace --description 'Enter workspace: zellij (immutable Linux host → archlinux distrobox)'
    set -l container archlinux

    # Already inside a Zellij session → nothing to do
    if set -q ZELLIJ
        echo "[workspace] already inside a Zellij session" >&2
        return 1
    end

    # Direct-launch paths:
    #   - macOS
    #   - already inside a container (distrobox/toolbox/podman)
    #   - Linux on a mutable distro (no /run/ostree-booted) → no need to hop into distrobox
    if test (uname) = Darwin
        or test -e /run/.containerenv
        or set -q CONTAINER_ID
        or not test -e /run/ostree-booted
        if not command -q zellij
            echo "[workspace] zellij not found in PATH" >&2
            return 1
        end
        zellij attach MAIN; or exec zellij -s MAIN
        return
    end

    # Immutable Linux host (ostree-based: bluefin/silverblue/kinoite/...) → hop into distrobox
    if not command -q distrobox
        echo "[workspace] distrobox not installed on host" >&2
        echo "[workspace] install it (e.g. 'rpm-ostree install distrobox' on bluefin) and retry" >&2
        return 1
    end

    if not distrobox list --no-color 2>/dev/null | awk -F'|' 'NR>1 {gsub(/ /,"",$2); print $2}' | grep -qx $container
        echo "[workspace] distrobox container '$container' does not exist" >&2
        echo "[workspace] available containers:" >&2
        distrobox list >&2
        echo "[workspace] create it with: just distrobox-archlinux  (or 'distrobox create --name $container ...')" >&2
        return 1
    end

    exec distrobox enter $container -- fish -lic workspace
end
