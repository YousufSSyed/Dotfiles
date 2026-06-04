{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.linkwarden = {
    enable = true;
    secretFiles.NEXTAUTH_SECRET = config.sops.secrets."NEXTAUTH_SECRET".path;
    enableRegistration = true;
    environment = {
      NEXTAUTH_URL = "http://localhost:3000/api/v1/auth";
    };
  };

  # services.immich = {
  #   enable = true;
  #   accelerationDevices = null;
  #   mediaLocation = "/home/yousuf/Assets/Immich";
  # };
  # users.users.immich.extraGroups = [
  #   "video"
  #   "render"
  # ];

}
