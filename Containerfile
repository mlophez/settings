FROM ghcr.io/ublue-os/bluefin:gts

# Hyprland session and Wayland desktop tooling from lionheartp/Hyprland COPR
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y copr enable lionheartp/Hyprland && \
    dnf5 install -y \
      `# Hyprland compositor and core ecosystem` \
      hyprland \
      hyprlock \
      hyprpaper \
      hypridle \
      hyprpicker \
      xdg-desktop-portal-hyprland \
      `# Wayland desktop utilities (bar, launcher, notifications, wallpaper, lock)` \
      waybar \
      rofi-wayland \
      wlogout \
      mako \
      swaylock \
      `# Screenshot, clipboard, media keys` \
      grim \
      slurp \
      wl-clipboard \
      brightnessctl \
      playerctl \
      `# Qt theming` \
      qt5ct && \
    dnf5 -y copr disable lionheartp/Hyprland

# Custom configs
# COPY default/<file> /etc/<file>

RUN bootc container lint
