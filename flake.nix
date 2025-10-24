{
  description = "Home Manager configuration of mlr (Linux + macOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixGL solo lo usamos en Linux
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland también solo aplica en Linux
    hyprland = {
      url = "github:nixos/nixpkgs?rev=89c49874fb15f4124bf71ca5f42a04f2ee5825fd";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."macos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/macos.nix
        ];
      };
    };
}

