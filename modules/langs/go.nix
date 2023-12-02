{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.go;
in {
  options = { langs.go = { enable = mkEnableOption { default = false; }; }; };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ go gopls ]; };
}
