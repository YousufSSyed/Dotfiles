{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./nixos.nix
    ./Other/nixos_laptop_hardware.nix
  ];

  services.avahi.enable = true;
  services.geoclue2.enable = true;
  services.geoclue2.submitData = true;
  services.geoclue2.enableWifi = false;
  services.geoclue2.enableDemoAgent = lib.mkForce true;

  system.autoUpgrade.dates = "1:00";

    networking = {
    hostName = "NixOS-Laptop";
    };
}
