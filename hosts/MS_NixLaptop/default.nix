{ ... }:

{
  imports = [
    ../../modules/nixos/base.nix
    ./hardware-configuration.nix
    ./tlp.nix
  ];
}
