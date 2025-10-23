{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # Define un package "default" que se pueda instalar con nix profile install
    packages.${system}.install = pkgs.buildEnv {
      name = "macos";
      paths = [
        # Desktop
        pkgs.nerd-fonts.fira-code

        # NETWORK
        pkgs.curl
        pkgs.wget
        #pkgs.autossh
        #pkgs.sshpass
        #pkgs.wol
        #pkgs.inetutils
        #pkgs.dnsutils
        #pkgs.nmap

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
        pkgs.starship

        # ZSH
        #pkgs.zsh
        #pkgs.zsh-completions
        #pkgs.zsh-autosuggestions
        #pkgs.zsh-syntax-highlighting

        #pkgs.unrar
        pkgs.unzip
        pkgs.gnutar
        pkgs.p7zip
        pkgs.zip

        pkgs.nano
        pkgs.neovim
        #pkgs.neovide
        # pkgs.prettier

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
        #pkgs.terraform
        #pkgs.terragrunt

        ## CONTAINERS
        pkgs.skopeo

        # NOMAD
        # nomad

        # KUBERNETES
        pkgs.kubectl
        pkgs.kubecolor
        pkgs.kustomize
        pkgs.stern
        #pkgs.helm
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
    };
  };
}
