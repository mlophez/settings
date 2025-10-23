{
  description = "Home Manager configuration of mlr";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    hyprland = {
      url = "github:nixos/nixpkgs?rev=89c49874fb15f4124bf71ca5f42a04f2ee5825fd"; # 0.41.2
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
