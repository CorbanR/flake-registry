{
  description = "Shell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        nixpkgsConfig = {
          config = {
            allowUnfree = true;
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          inherit (nixpkgsConfig) config;
        };
      in {
        # nix run '.#fmt'
        apps.fmt = flake-utils.lib.mkApp {
          drv = pkgs.writeScriptBin "fmt" ''
            ${pkgs.alejandra}/bin/alejandra "$@" .
          '';
        };
        devShells.default = import ./shell.nix {inherit system pkgs;};
      }
    );
}
