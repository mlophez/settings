{ config, pkgs, hypr, ... }:

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
  home.activation = {
    postActivation = ''
      ~/.nix-profile/bin/rsync -raL --delete-after ~/.nix-profile/share/icons/ .local/share/icons/
    '';
  };

  home.packages = [
    # Desktop Enviroment
    pkgs.nixgl.auto.nixGLDefault
    hypr.hyprland
    hypr.hyprlock
    hypr.hyprpaper
    hypr.hypridle
    hypr.xwayland
    pkgs.waybar
    pkgs.swww
    pkgs.pywal
    pkgs.wofi
    pkgs.rofi-wayland
    pkgs.mako
    pkgs.wlogout
    pkgs.foot
    pkgs.alacritty
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
    pkgs.ranger
    pkgs.nwg-look
    pkgs.fira-code-nerdfont
    pkgs.vscode

    # Fonts
    (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
    # Themes
    pkgs.bibata-cursors
    # pkgs.catppuccin
    (pkgs.catppuccin-gtk.override { variant = "mocha"; accents = ["peach"]; })
    pkgs.catppuccin-qt5ct

    # NETWORK
    pkgs.autossh
    pkgs.sshpass
    pkgs.wol
    pkgs.curl
    pkgs.wget
    pkgs.traceroute
    pkgs.inetutils
    pkgs.dnsutils
    pkgs.nmap

    # SHELL
    # pkgs.bash
    pkgs.fzf
    pkgs.expect
    pkgs.bc
    pkgs.jq
    pkgs.yq
    pkgs.eza
    pkgs.lsd
    pkgs.colordiff
    pkgs.bat
    pkgs.dialog
    pkgs.tmux
    pkgs.zellij
    pkgs.entr
    pkgs.ripgrep
    pkgs.fd
    pkgs.xdg-ninja

    # ZSH
    pkgs.zsh
    pkgs.zsh-completions
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.starship

    #pkgs.unrar
    pkgs.unzip
    pkgs.gnutar
    pkgs.p7zip
    pkgs.zip

    pkgs.nano
    hypr.neovim
    pkgs.neovide
    # pkgs.prettier

    pkgs.gnupg
    pkgs.paperkey
    pkgs.zbar
    pkgs.pass
    pkgs.passExtensions.pass-otp
    pkgs.cryfs

    # BACKUPS
    pkgs.borgbackup
    pkgs.rsync
    pkgs.rclone

    # UTILS
    pkgs.htop
    pkgs.btop
    pkgs.man
    pkgs.just

    ##################### DEV/OPS #####################
    # GIT
    pkgs.git
    pkgs.git-lfs
    pkgs.delta
    pkgs.devbox

    # ANSIBLE
    pkgs.ansible
    pkgs.ansible-lint

    # TERRAFORM
    pkgs.terraform
    pkgs.terragrunt

    ## CONTAINERS
    pkgs.skopeo

    # NOMAD
    # nomad

    # KUBERNETES
    pkgs.kubectl
    pkgs.kubecolor
    pkgs.kustomize
    pkgs.stern
    pkgs.helm
    pkgs.kompose
    pkgs.k9s
    pkgs.trivy
    pkgs.kubeseal

    # CI/CD
    # dagger

    # API
    pkgs.httpie
    pkgs.curlie

    # AWS
    # pkgs.eksctl
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
  ];

  #home.packages = lib.mkAfter (with pkgs; [
  #  kubectl
  #]);

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
    # ".bash_profile".text = ''
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
    ZDOTDIR = "${config.home.homeDirectory}/.config/zsh";
    EDITOR = "nvim";
  };

  #home.pointerCursor = {
  #  gtk.enable = true;
  #  # x11.enable = true;
  #  package = pkgs.bibata-cursors;
  #  name = "Bibata-Modern-Classic";
  #  size = 16;
  #};

  #gtk = {
  #  enable = true;

  #  theme = {
  #    package = pkgs.flat-remix-gtk;
  #    name = "Flat-Remix-GTK-Grey-Darkest";
  #  };

  #  iconTheme = {
  #    package = pkgs.gnome.adwaita-icon-theme;
  #    name = "Adwaita";
  #  };

  #  #font = {
  #  #  name = "Sans";
  #  #  size = 11;
  #  #};
  #};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
