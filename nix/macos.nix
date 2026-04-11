{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.stateVersion = "24.05"; # Please read the comment before changing.
  home.username = "miguel.lopez";
  home.homeDirectory = "/Users/miguel.lopez";
  home.enableNixpkgsReleaseCheck = false;
  # Let Home Manager install and manage itself.
  home.packages = [
    # FONTS
    pkgs.nerd-fonts.fira-code
    # NETWORK
    pkgs.curl
    pkgs.wget
    pkgs.autossh
    pkgs.sshpass
    pkgs.wol
    pkgs.inetutils
    pkgs.dnsutils
    pkgs.nmap
    pkgs.mitmproxy
    pkgs.httpie
    pkgs.curlie
    pkgs.ngrok
    # ZSH
    #pkgs.zsh
    pkgs.zsh-completions
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    # SHELL
    pkgs.fish
    pkgs.nushell
    # TOOLS
    pkgs.fzf
    pkgs.expect
    pkgs.bc
    pkgs.jq
    pkgs.yq
    pkgs.tree
    pkgs.eza
    pkgs.lsd
    pkgs.colordiff
    pkgs.bat
    pkgs.gnused
    pkgs.dialog
    pkgs.tmux
    pkgs.zellij
    pkgs.entr
    pkgs.ripgrep
    pkgs.fd
    pkgs.starship
    # FILES
    pkgs.unrar
    pkgs.unzip
    pkgs.gnutar
    pkgs.p7zip
    pkgs.zip
    # EDITOR
    pkgs.nano
    pkgs.neovim
    # LINTERS
    pkgs.prettier
    pkgs.mdformat
    # pkgs.mdformat-tables
    # SECURITY
    pkgs.gnupg
    pkgs.paperkey
    #pkgs.zbar
    #pkgs.pass
    #pkgs.passExtensions.pass-otp
    #pkgs.cryfs
    # BACKUPS
    #pkgs.borgbackup
    pkgs.rsync
    pkgs.rclone
    # UTILS
    pkgs.htop
    pkgs.btop
    pkgs.man
    pkgs.just
    ##################### DEVELOPMENT #####################
    # PYTHON
    pkgs.python3
    pkgs.pyright
    pkgs.mypy
    pkgs.isort
    pkgs.black
    pkgs.ruff
    # pkgs.poetry
    pkgs.uv
    # GO
    pkgs.go
    pkgs.go-tools
    pkgs.gopls
    pkgs.delve
    # NODE
    pkgs.nodejs
    pkgs.yarn
    pkgs.pnpm
    # TYPESCRIPT
    pkgs.typescript
    # RUST
    pkgs.rustup
    # pkgs.rust-analyzer
    # LUA
    # luarocks
    # stylua
    pkgs.lua-language-server
    # JAVA
    # pkgs.jdk
    pkgs.jdk17
    # pkgs.jdk11
    # pkgs.jdk8
    pkgs.maven
    # OTHERS
    pkgs.fastlane
    ##################### DEV/OPS #####################
    # GIT
    pkgs.git
    pkgs.git-lfs
    pkgs.delta
    pkgs.lazygit
    # ANSIBLE
    pkgs.ansible
    pkgs.ansible-lint
    # TERRAFORM
    # pkgs.terraform
    pkgs.terraform-ls
    #pkgs.terragrunt
    ## CONTAINERS
    pkgs.skopeo
    # KUBERNETES
    pkgs.kubectl
    pkgs.kubecolor
    pkgs.kustomize
    pkgs.stern
    pkgs.conftest
    #pkgs.krr
    # pkgs.helm
    pkgs.kompose
    pkgs.k9s
    pkgs.trivy
    pkgs.kubeseal
    # CI/CD
    # dagger
    # AWS
    # pkgs.eksctl
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
  ];
  programs.home-manager.enable = true;
  # programs.java = {
  #   enable = true;
  #   packages = [
  #     pkgs.jdk8
  #     pkgs.jdk11
  #     pkgs.jdk17
  #   ];
  #   defaultPackage = pkgs.jdk17;
  # };
}
