FROM ghcr.io/ublue-os/bluefin:gts

# Enable lionheartp/Hyprland COPR (newer Hyprland stack than Fedora main)
RUN dnf5 -y copr enable lionheartp/Hyprland

# Install Hyprland session and Wayland desktop tooling
RUN dnf5 install -y \
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
      swww \
      swaylock \
      `# Screenshot, clipboard, media keys` \
      grim \
      slurp \
      wl-clipboard \
      brightnessctl \
      playerctl \
      `# Qt theming` \
      qt5ct

# Disable COPR and clean caches
RUN dnf5 -y copr disable lionheartp/Hyprland && \
    dnf5 clean all

# Custom configs
# COPY default/<file> /etc/<file>

RUN bootc container lint
