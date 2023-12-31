# Thanks devshell! https://github.com/numtide/devshell/blob/main/flake-module.nix

localFlake:
{ lib, flake-parts-lib, inputs, ... }:
let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mkOption types;
in {
  options = {
    perSystem = mkPerSystemOption ({ config, pkgs, system, ... }: {
      options.denvs = mkOption {
        type = types.lazyAttrsOf (types.submoduleWith {
          modules = import ./modules/modules.nix { inherit pkgs lib; };
        });
        default = { };
      };
      config = {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };

        devShells = let
          mkShell = cfg:
            let
              exports = lib.foldlAttrs (acc: name: value: ''
                ${acc}
                export ${name}=${value}
              '') "" cfg.env;

              scriptPackages = lib.foldlAttrs (acc: name: value:
                acc ++ [ (pkgs.writeScriptBin name value.text) ]) [ ]
                cfg.scripts;

              packages = cfg.packages ++ scriptPackages;

              shellHook = ''
                ${exports}
                 
                ${cfg.init}
              '';
            in pkgs.mkShell {
              buildInputs = packages;
              shellHook = shellHook;
            };
        in lib.mapAttrs (_name: denv: mkShell denv.denv) config.denvs;
      };
    });
  };
}
