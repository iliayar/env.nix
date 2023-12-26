{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.lua;
in {
  options = { langs.lua = { enable = mkEnableOption { default = false; }; }; };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ nodePackages.lua-fmt ]; };
}
