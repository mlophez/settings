{
  description = "Nix CLI packages for mlr's workstation (Linux + macOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Construye un único paquete que agrupa, por symlinks, todo el tooling
      # CLI de una plataforma. Es lo que se instala en el perfil de Nix.
      mkEnv = system: extraFile:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.buildEnv {
          name = "workstation-env";
          paths = (import ./nix/packages.nix { inherit pkgs; })
            ++ (import extraFile { inherit pkgs; });
          # Incluye las man pages de los paquetes que las publican en un
          # output aparte. No se añade "doc": arrastra builds muy pesadas.
          extraOutputsToInstall = [ "man" ];
        };
    in
    {
      packages.x86_64-linux.default = mkEnv "x86_64-linux" ./nix/linux.nix;
      packages.aarch64-darwin.default = mkEnv "aarch64-darwin" ./nix/macos.nix;
    };
}
