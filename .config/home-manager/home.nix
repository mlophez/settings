{ config, pkgs, ... }:

let
  pkgsNixGL = import <nixgl> {}; # https://github.com/nix-community/nixGL/archive/main.tar.gz
  pkgs2405 = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/24.05.tar.gz"; # Reemplaza con la versión deseada
  }) {};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mlr";
  home.homeDirectory = "/home/mlr";
  home.enableNixpkgsReleaseCheck = false;
  xdg.stateHome = "/home/mlr/.local/share/state";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # install -m 644 -o root -g root ~/.nix-profile/etc/pam.d/hyprlock /etc/pam.d/hyprlock

  home.packages = [
    pkgsNixGL.auto.nixGLDefault
    pkgs2405.hyprland
    pkgs2405.hyprlock
    pkgs2405.hyprpaper
    pkgs2405.hypridle
    # pkgs.hyprland
    # pkgs.hyprlock
    # pkgs.hyprpaper
    # pkgs.hypridle
    # pkgs.xwayland
    pkgs.waybar
    pkgs.swww
    pkgs.pywal
    pkgs.wofi
    pkgs.rofi-wayland
    pkgs.mako
    pkgs.wlogout
    pkgs.foot
    pkgs.just
    pkgs.brightnessctl
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.libnotify
    pkgs.wev
    pkgs.grim
    pkgs.slurp
    pkgs.swappy
    pkgs.swaylock-effects
    pkgs.networkmanagerapplet
    pkgs.devbox
    pkgs.ranger
    pkgs.nwg-look
    pkgs.fira-code-nerdfont
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mlr/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
