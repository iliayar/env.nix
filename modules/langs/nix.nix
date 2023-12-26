{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.nix;
in {
  options = { langs.nix = { enable = mkEnableOption { default = false; }; }; };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ nixfmt ]; };
}
