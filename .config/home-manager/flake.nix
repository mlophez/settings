{
  description = "Home Manager configuration of mlr";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    hyprland = {
      #url = "github:nixos/nixpkgs?rev=10a9d8c7283e555d54dd7fcb35bc21e215aae297"; # 0.40.0
      url = "github:nixos/nixpkgs?rev=25cb8f71c487dd288cd29a7a6715fb7dde9fa461"; # 0.41.2
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.nixgl.overlay ];
        config.allowUnfree = true;
      };
      hypr = import inputs.hyprland {
        system = "x86_64-linux";
      };
    in {
      homeConfigurations."mlr" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit hypr;
        };

        modules = [ ./home.nix ];
      };
    };
}
