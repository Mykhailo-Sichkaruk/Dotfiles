{
  description = "A flake that manages both NixOS and Home Manager configurations along with dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    nix-auth.url = "github:numtide/nix-auth";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nur,
      nix-auth,
      nixvim,
      home-manager,
      nix-index-database,
      nixgl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          nur.overlays.default
        ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-nix-auth = import nix-auth {
        inherit system;
      };
      localPackages = rec {
        archi = pkgs.callPackage ./pkgs/by-name/ar/archi/package.nix { };
        jarchi = pkgs.callPackage ./pkgs/by-name/ja/jarchi/package.nix {
          inherit archi;
        };
        archiMcpPlugin = pkgs.callPackage ./pkgs/by-name/ar/archi-mcp-plugin/package.nix { };
        archiDropins = pkgs.symlinkJoin {
          name = "archi-dropins";
          paths = [
            jarchi
            archiMcpPlugin
          ];
        };
        nixvimMinimal = import ./pkgs/by-name/ni/nixvim-minimal/package.nix {
          inherit
            nixvim
            pkgs
            pkgs-unstable
            system
            ;
        };
        playwrightBrowsers1217 = pkgs.callPackage ./pkgs/by-name/pl/playwright-browsers-1217/package.nix { };
      };
    in
    {
      packages.${system} = localPackages // {
        nixvim-minimal = localPackages.nixvimMinimal;
        playwright-browsers-1217 = localPackages.playwrightBrowsers1217;
      };

      devShells.${system}.playwright-1217 = pkgs.mkShell {
        packages = [
          pkgs.nodejs
          pkgs.yarn
          localPackages.playwrightBrowsers1217
        ];

        shellHook = ''
          export PLAYWRIGHT_BROWSERS_PATH=${localPackages.playwrightBrowsers1217}
        '';
      };

      apps.${system}.nixvim-minimal = {
        type = "app";
        program = "${localPackages.nixvimMinimal}/bin/nixvim-minimal";
      };

      nixosConfigurations.MS_NixLaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.overlays = [
              nixgl.overlay
              nur.overlays.default
            ];
            nixpkgs.config.allowUnfree = true;
          }
          nix-index-database.nixosModules.default
          ./root/etc/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit pkgs-unstable;
              inherit pkgs-nix-auth;
              inherit localPackages;
            };
            home-manager.users.ms = import ./home/.config/home-manager/home.nix;
          }
        ];
      };
    };
}
