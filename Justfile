platform := os()
image := "localhost/workstation" # solo usado por legacy/system.just (flujo bootc)
distrobox_image := "docker.io/library/archlinux:latest"
# distrobox_image := "quay.io/toolbx-images/archlinux-toolbox:latest"
# distrobox_image := "ghcr.io/ublue-os/arch-distrobox:latest"
chooser := "fzf --preview 'just --show {}'"

[private]
default:
    @just -u -l

[private]
ui:
    @just --choose --unsorted --chooser {{ quote(chooser) }}

import 'just/general.just'
import 'just/system.just'
import 'just/apps.just'
import 'just/setup.just'
import 'just/nix.just'
import 'just/rust.just'
import 'just/distrobox.just'
import 'just/settings.just'
import 'just/gnome.just'
import 'just/backup.just'
