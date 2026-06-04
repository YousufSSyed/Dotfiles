{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.avahi.enable = true;
  services.geoclue2.enable = true;
  services.geoclue2.submitData = true;
  services.geoclue2.enableWifi = false;
  services.geoclue2.enableDemoAgent = lib.mkForce true;

  services.syncthing.dataDir = "/home/yousuf/Sync/.Syncthing-Laptop/";
}
