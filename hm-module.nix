{ lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mkOption types;
in {
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, ... }: {
      options.denv = mkOption {
        type = types.submoduleWith {
          modules = import ./modules/modules.nix { inherit pkgs lib; };
        };
        default = { };
      };
      config = { home.packages = config.denv.denv.packages; };
    });
  };
}
