{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
  ];

  services.avahi.enable = true;
  services.geoclue2.enable = true;
  services.geoclue2.submitData = true;
  services.geoclue2.enableWifi = false;
  services.geoclue2.enableDemoAgent = lib.mkForce true;
}
