{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.coq;
in {
  options = {
    langs.coq = { enable = mkEnableOption { default = false; }; };
  };
  config = mkIf cfg.enable {
    denv.packages = with pkgs; [
        coq
    ];
  };
}
