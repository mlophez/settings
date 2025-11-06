#!/usr/bin/env bash
set -xeuo pipefail



###############################################################################



# Work around https://bugzilla.redhat.com/show_bug.cgi?id=1265295
# From https://github.com/coreos/fedora-coreos-config/blob/testing-devel/overlay.d/05core/usr/lib/systemd/journald.conf.d/10-coreos-persistent.conf
install -dm0755 /usr/lib/systemd/journald.conf.d/
echo -e "[Journal]\nStorage=persistent" > /usr/lib/systemd/journald.conf.d/10-persistent.conf

# See: https://src.fedoraproject.org/rpms/glibc/pull-request/4
# Basically that program handles deleting old shared library directories
# mid-transaction, which never applies to rpm-ostree. This is structured as a
# loop/glob to avoid hardcoding (or trying to match) the architecture.
for x in /usr/sbin/glibc_post_upgrade.*; do
    if test -f ${x}; then
        ln -srf /usr/bin/true ${x}
    fi
done

# Remove loader directory causing issues in Anaconda in unified core mode
# Will be obsolete once we start using bootupd
rm -rf /usr/lib/ostree-boot/loader

# Undo RPM scripts enabling units; we want the presets to be canonical
# https://github.com/projectatomic/rpm-ostree/issues/1803
rm -rf /etc/systemd/system/*
systemctl preset-all
rm -rf /etc/systemd/user/*
systemctl --user --global preset-all

# Workaround for https://bugzilla.redhat.com/show_bug.cgi?id=2218006
systemctl enable nfs-client.target



###############################################################################



# Setup unit & script for readonly sysroot migration:
# - https://fedoraproject.org/wiki/Changes/Silverblue_Kinoite_readonly_sysroot
# - https://bugzilla.redhat.com/show_bug.cgi?id=2060976

cat > /usr/lib/systemd/system/fedora-silverblue-readonly-sysroot.service <<'EOF'
[Unit]
Description=Fedora Silverblue Read-Only Sysroot Migration
Documentation=https://fedoraproject.org/wiki/Changes/Silverblue_Kinoite_readonly_sysroot
ConditionPathExists=!/var/lib/.fedora_silverblue_readonly_sysroot
RequiresMountsFor=/sysroot /boot
ConditionPathIsReadWrite=/sysroot

[Service]
Type=oneshot
ExecStart=/usr/libexec/fedora-silverblue-readonly-sysroot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

chmod 644 /usr/lib/systemd/system/fedora-silverblue-readonly-sysroot.service

cat > /usr/libexec/fedora-silverblue-readonly-sysroot <<'EOF'
#!/bin/bash

# Update an existing system to use a read only sysroot
# See https://fedoraproject.org/wiki/Changes/Silverblue_Kinoite_readonly_sysroot
# and https://bugzilla.redhat.com/show_bug.cgi?id=2060976

set -euo pipefail

main() {
    # Used to condition execution of this unit at the systemd level
    local -r stamp_file="/var/lib/.fedora_silverblue_readonly_sysroot"

    if [[ -f "${stamp_file}" ]]; then
        exit 0
    fi

    local -r ostree_sysroot_readonly="$(ostree config --repo=/sysroot/ostree/repo get "sysroot.readonly" &> /dev/null || echo "false")"
    if [[ "${ostree_sysroot_readonly}" == "true" ]]; then
        # Nothing to do
        touch "${stamp_file}"
        exit 0
    fi

    local -r boot_entries="$(ls -A /boot/loader/entries/ | wc -l)"

    # Ensure that we can read BLS entries to avoid touching systems where /boot
    # is not mounted
    if [[ "${boot_entries}" -eq 0 ]]; then
        echo "No BLS entry found: Maybe /boot is not mounted?" 1>&2
        echo "This is unexpected thus no migration will be performed" 1>&2
        touch "${stamp_file}"
        exit 0
    fi

    # Check if any existing deployment is still missing the rw karg
    local rw_kargs_found=0
    local count=0
    for f in "/boot/loader/entries/"*; do
        count="$(grep -c "^options .* rw" "${f}" || true)"
        if [[ "${count}" -ge 1 ]]; then
            rw_kargs_found=$((rw_kargs_found + 1))
        fi
    done

    # Some deployments are still missing the rw karg. Let's try to update them
    if [[ "${boot_entries}" -ne "${rw_kargs_found}" ]]; then
        ostree admin kargs edit-in-place --append-if-missing=rw || \
            echo "Failed to edit kargs in place with ostree" 1>&2
    fi

    # Re-check if any existing deployment is still missing the rw karg
    rw_kargs_found=0
    count=0
    for f in "/boot/loader/entries/"*; do
        count="$(grep -c "^options .* rw" "${f}" || true)"
        if [[ "${count}" -ge 1 ]]; then
            rw_kargs_found=$((rw_kargs_found + 1))
        fi
    done
    unset count

    # If all deployments are good, then we can set the sysroot.readonly option
    # in the ostree repo config
    if [[ "${boot_entries}" -eq "${rw_kargs_found}" ]]; then
        echo "Setting up the sysroot.readonly option in the ostree repo config"
        ostree config --repo=/sysroot/ostree/repo set "sysroot.readonly" "true"
        touch "${stamp_file}"
        exit 0
    fi

    # If anything else before failed, we will retry on next boot
    echo "Will retry next boot" 1>&2
    exit 0
}

main "${@}"
EOF

chmod 755 /usr/libexec/fedora-silverblue-readonly-sysroot

# Enable the corresponding unit
systemctl enable fedora-silverblue-readonly-sysroot.service
