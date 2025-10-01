{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.haskell;
in {
  options = {
    langs.haskell = {
      enable = mkEnableOption { default = false; };
      extraPackages = mkOption { default = hpkgs: [ ]; };
    };
  };
  config = mkIf cfg.enable (let
    preparedGhc = pkgs.haskellPackages.ghcWithPackages
      (hpkgs: [ ] ++ (cfg.extraPackages hpkgs));
  in {
    denv.packages = with pkgs; [
      haskell-language-server
      preparedGhc
      stack
      cabal-install
      hlint
    ];
  });
}
