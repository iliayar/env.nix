{ config, pkgs, lib, ... }:
with lib;
let cfg = config.programs.hello;
in {
  options = {
    programs.hello = { enable = mkEnableOption { default = false; }; };
  };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ hello ]; };
}
