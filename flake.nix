{
  description = "A flake that manages both NixOS and Home Manager configurations along with dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Change if on a different platform (aarch64-linux, etc.)
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.MS_NixLaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./root/etc/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.ms = import ./home/.config/home-manager/home.nix;
          }
        ];
      };

      homeManagerConfigurations.username = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/.config/home-manager/home.nix
        ];
      };

    };
}
