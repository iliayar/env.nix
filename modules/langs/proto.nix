{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.protobuf;
in {
  options = { langs.protobuf = { enable = mkEnableOption { default = false; }; }; };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ buf api-linter ]; };
}
