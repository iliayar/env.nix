{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.python;
in {
  options = {
    langs.python = {
      enable = mkEnableOption { default = false; };
      packages = mkOption {
        default = (ps: [ ]);
        type = mkOptionType {
          name = "Python packages function";
          merge = (loc: defs:
            foldr ({ value, ... }: a: (ps: (value ps) ++ (a ps))) (ps: [ ])
            defs);
        };
      };
    };
  };
  config = mkIf cfg.enable { denv.packages = with pkgs; [ (python3.withPackages cfg.packages) ]; };
}
