{ config, pkgs, lib, ... }:
with lib;
let cfg = config.denv;
in {
  options = {
    denv.packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };
}
