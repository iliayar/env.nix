{ config, pkgs, lib, ... }:
with lib;
let cfg = config.denv;
in {
  options = {
    denv.packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
    denv.env = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
    denv.init = mkOption {
      default = ''
        # Some init scripts
      '';
      type = types.lines;
    };
  };
}
