{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.python;
in {
  options = {
    langs.python = {
      enable = mkEnableOption { default = false; };
      jupyter = {
        enable = mkEnableOption { default = false; };
      };
      ml.enable = mkEnableOption { default = false; };
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
  config = mkMerge [
    (mkIf (cfg.enable && cfg.ml.enable) {
        langs.python.packages = pypkgs: with pypkgs; [ scikit-learn ];
    })
    (mkIf (cfg.enable && cfg.jupyter.enable) {
        langs.python.packages = pypkgs: with pypkgs; [ jupyter jupyterlab ];
    })
    (mkIf cfg.enable { denv.packages = with pkgs; [ (python3.withPackages cfg.packages) ]; })
  ];
}
