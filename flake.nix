{
  description = "A flake that manages the NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-cuda.url = "github:nixos/nixpkgs/nixos-25.11-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    {
      home-manager,
      nix-index-database,
      nixgl,
      nixpkgs,
      nixpkgs-cuda,
      nixpkgs-unstable,
      nixvim,
      nur,
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

      pkgs-cuda = import nixpkgs-cuda {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = [ "8.6" ];
        };
      };

      localPackages = import ./pkgs-local {
        inherit
          nixvim
          pkgs
          pkgs-cuda
          pkgs-unstable
          system
          ;
      };

      homeSpecialArgs = {
        inherit pkgs-unstable localPackages;
        playwrightBrowsers = null;
      };

      laptopHomeSpecialArgs = homeSpecialArgs // {
        playwrightBrowsers = localPackages.playwrightBrowsers1217;
      };
    in
    {
      homeConfigurations.portable = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = homeSpecialArgs;
        modules = [
          ./home-portable.nix
          {
            home.username = "ms";
            home.homeDirectory = "/home/ms";
          }
        ];
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
          ./nixos.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = laptopHomeSpecialArgs;
            home-manager.users.ms = import ./home-manager.nix;
          }
        ];
      };
    };
}
