{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    denv = {
      url = "github:iliayar/env.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, denv, ... }:
    flake-parts.lib.mkFlake { inputs = denv.inputs; } {
      imports = [ denv.flakeModules.default ];
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        denvs.default = {
          # programs.hello.enable = true; 

          # services.postgres = {
          #   enable = true;
          #   serve = "local";
          #   defaultDatabase = "postgres";
          #   autoStart = true;
          # };

          # langs.go = {
          #   enable = true;
          # };

          # langs.ocaml = {
          #   enable = true;
          # };

          # langs.protobuf = {
          #   enable = true;
          # };

          # langs.nix = {
          #   enable = true;
          # };

          # langs.lua = {
          #   enable = true;
          # };
        };
      };
      flake = { };
    };
}
