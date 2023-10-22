# FIXME: Not checked
{ lib, config, pkgs, ... }:
let inherit (lib) mkOption types;
in {
  options.denv = mkOption {
    type = types.submoduleWith {
      modules = import ./modules/modules.nix { inherit pkgs lib; };
    };
    default = { };
  };
  config = { environment.systemPackages = config.denv.denv.packages; };
}
