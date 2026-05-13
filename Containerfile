FROM ghcr.io/ublue-os/bluefin:gts

# Hyprland session + tooling derived from config/hypr/* invocations
RUN dnf5 install -y \
      hyprland \
      hyprlock \
      hyprpaper \
      hypridle \
      hyprpicker \
      xdg-desktop-portal-hyprland \
      waybar \
      rofi-wayland \
      wlogout \
      mako \
      swww \
      swaylock \
      grim \
      slurp \
      wl-clipboard \
      brightnessctl \
      playerctl \
      qt5ct \
      NetworkManager-applet \
      polkit-gnome \
    && dnf5 clean all

# Custom configs
# COPY default/<file> /etc/<file>

RUN bootc container lint
