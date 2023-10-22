{ config, pkgs, lib, ... }:
with lib;
let cfg = config.denv;
in {
  options = {
    denv.packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };

    denv.package = mkOption { type = types.package; };
  };

  config = { denv.package = pkgs.mkShell { buildInputs = cfg.packages; }; };
}
