{ config, pkgs, lib, ... }:
with lib;
let cfg = config.langs.ocaml;
in {
  options = {
    langs.ocaml = { enable = mkEnableOption { default = false; }; };
  };
  config = mkIf cfg.enable {
    denv.packages = with pkgs; [
      ocaml
      dune_3
      ocamlPackages.findlib
      ocamlPackages.utop
      ocamlPackages.odoc
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat

      pkg-config

      # TODO: choose build system
      nodePackages.esy
    ];
  };
}
