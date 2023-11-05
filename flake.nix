{
  description = "Configure environment using Nix";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05"; };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    ({ withSystem, flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
        flakeModules.default =
          importApply ./flake-module.nix { inherit withSystem; };
      in {
        imports = [ flakeModules.default ];
        systems =
          [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
        perSystem = { config, self', inputs', pkgs, system, ... }: {
          denvs.default = { programs.hello.enable = true; };
        };
        flake = {
          inherit flakeModules;
          homeManagerModules.default = import ./hm-module.nix;

          templates = rec {
            default = basic;
            basic = {
              path = ./templates/basic;
              description = "Empty flake using dev.nix";
            };
            full = {
              path = ./templates/full;
              description =
                "Empty flake using dev.nix with all options commented";
            };
          };
        };
      });
}
