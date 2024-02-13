{ config, pkgs, lib, ... }:
with lib;
let cfg = config.tools.grpc;
in {
  options = {
    tools.grpc = { enable = mkEnableOption { default = false; }; };
  };
  config = mkIf cfg.enable {
    denv.packages = with pkgs; [ grpcurl ];
  };
}
