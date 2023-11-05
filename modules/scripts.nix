{ config, pkgs, lib, ... }:
with lib;
let cfg = config.scripts;
in {
  options = {
    scripts = mkOption {
      default = { };
      type = types.attrsOf (types.submodule {
        options = { text = mkOption { type = types.str; }; };
      });
    };
  };
  config = { denv.scripts = cfg; };
}
