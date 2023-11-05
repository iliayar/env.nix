{ config, pkgs, lib, ... }:
with lib;
let cfg = config.denv;
in {
  options = {
    denv = {
      packages = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
      env = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };
      init = mkOption {
        default = ''
          # Some init scripts
        '';
        type = types.lines;
      };
      scripts = mkOption {
        default = { };
        type = types.attrsOf (types.submodule {
          options = { text = mkOption { type = types.str; }; };
        });
      };
    };
  };
}
