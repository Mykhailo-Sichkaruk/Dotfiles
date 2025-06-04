{
  description = "A flake that manages both NixOS and Home Manager configurations along with dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
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

      homeManagerConfigurations.ms = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/.config/home-manager/home.nix
        ];
      };
    };
}
