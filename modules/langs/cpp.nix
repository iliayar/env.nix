{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.cpp;
in {
  options = { langs.cpp = { enable = mkEnableOption { default = false; }; }; };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ clang cmake ]; };
}
