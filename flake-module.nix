# Thanks devshell! https://github.com/numtide/devshell/blob/main/flake-module.nix

localFlake:
{ lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mkOption types;
in {
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, ... }: {
      options.denvs = mkOption {
        type = types.lazyAttrsOf (types.submoduleWith {
          modules = import ./modules/modules.nix { inherit pkgs lib; };
        });
        default = { };
      };
      config = {
        devShells = let
          mkShell = cfg:
            let
              exports = lib.foldlAttrs (acc: name: value: ''
                ${acc}
                export ${name}=${value}
              '') "" cfg.env;
            in pkgs.mkShell {
              buildInputs = cfg.packages;
              shellHook = ''
                ${exports}
                 
                ${cfg.init}
              '';
            };
        in lib.mapAttrs (_name: denv: mkShell denv.denv) config.denvs;
      };
    });
  };
}
