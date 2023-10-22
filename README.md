# env.nix

## Shell
```nix
{
  inputs = {
    # ...
    denv = {
      url = "github:iliayar/env.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, denv, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ 
        # ...
        denv.flakeModules.default 
      ];
      # ...
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # ...
        denvs.default = { 
          programs.hello.enable = true; 
        };
      };
      # ...
    };
}
```
Or just

```shell
nix flake init -t github:iliayar/env.nix
```

## Home Manager
First add module to home-manager configuration
```nix
{
  inputs = {
    # ...

    denv = {
      url = "github:iliayar/env.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ...
  };

  outputs = { denv, home-manager, ... }: {
    homeConfiguration = home-manager.lib.homeManagerConfiguration rec {
      # ...
      modules = [
        # ...
        denv.homeManagerModules.default
      ];
    }
  };
}
```

Example usage somewhere in config
```nix
{ ... }: {
  # ...
  denv.programs.hello.enable = true;
}
```
