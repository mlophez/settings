[private]
distrobox-setup: && distrobox-autostart
  -distrobox rm archlinux -f

  distrobox-create --nvidia -Y -n archlinux --image ghcr.io/ublue-os/arch-distrobox:latest

  distrobox enter archlinux -- sudo pacman-key --init
  distrobox enter archlinux -- sudo pacman -Syu --noconfirm
  distrobox enter archlinux -- sudo pacman --needed --noconfirm -S wezterm nix
  distrobox enter archlinux -- sudo pacman --needed --noconfirm -S $(cat $(pwd)/packages/archlinux.lst | grep -v "^ *#" | tr '\n' ' ')

  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
  distrobox enter archlinux -- sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
  distrobox enter archlinux -- sudo ln -sf /run/host/usr/share/ublue-os /usr/share/ublue-os

  distrobox enter archlinux -- distrobox-export --app wezterm

[private]
distrobox-autostart:
  #!/bin/bash
  mkdir -p $HOME/.config/autostart/
  cat << EOF > $HOME/.config/autostart/archlinux.desktop
  [Desktop Entry]
  Name=Archlinux
  Comment=Archlinux Distrobox
  Exec=/bin/bash -c 'distrobox enter archlinux -- echo'
  Type=Application
  EOF

[private]
distrobox-host-alias:
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/distrobox
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/podman
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/flatpak
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/gsettings
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/dconf
  sudo ln -sf /usr/sbin/distrobox-host-exec /usr/bin/rofi

[private]
distrobox-export-apps:
  type alacritty &>/dev/null && distrobox-export --bin /usr/bin/alacritty --export-path $HOME/.local/bin
  type kitty &>/dev/null && distrobox-export --bin /usr/bin/kitty --export-path $HOME/.local/bin
  type code &>/dev/null && distrobox-export --app code


