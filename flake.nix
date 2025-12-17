{
  description = "A flake that manages both NixOS and Home Manager configurations along with dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nur,
      home-manager,
      nixgl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay nur.overlays.default ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.MS_NixLaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.overlays = [ nixgl.overlay nur.overlays.default ];
            nixpkgs.config.allowUnfree = true;
          }
          ./root/etc/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
            home-manager.users.ms = import ./home/.config/home-manager/home.nix;
          }
        ];
      };

      homeManagerConfigurations.ms = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit pkgs-unstable;
        modules = [
          ./home/.config/home-manager/home.nix
        ];
      };
    };
}
