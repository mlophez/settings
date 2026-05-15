FROM ghcr.io/ublue-os/bluefin:gts

# Hyprland session and Wayland desktop tooling from lionheartp/Hyprland COPR
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    dnf5 -y copr enable lionheartp/Hyprland && \
    dnf5 -y copr enable wezfurlong/wezterm-nightly && \
    dnf5 install -y \
      hyprland \
      hyprlock \
      hyprpaper \
      hypridle \
      hyprpicker \
      hyprshot \
      hyprsunset \
      hyprpolkitagent \
      xdg-desktop-portal-hyprland \
      waybar \
      rofi-wayland \
      wlogout \
      mako \
      swaylock \
      grim \
      slurp \
      wl-clipboard \
      brightnessctl \
      playerctl \
      wezterm \
      qt5ct \
      && \
    dnf5 -y copr disable lionheartp/Hyprland && \
    dnf5 -y copr disable wezfurlong/wezterm-nightly && \
    dnf5 clean all && rm -rf /var/lib/dnf

# Custom configs
# COPY default/<file> /etc/<file>

RUN bootc container lint
