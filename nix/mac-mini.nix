{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
      environment.systemPackages =
      with pkgs; [ 
        # Apps
        iina
        syncthing-macos
      ];

      programs.fish.enable = true;

      system.primaryUser = "yousuf";
      system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
      system.defaults.dock.mineffect = "scale";
      system.defaults.dock.minimize-to-application = true;

      system.defaults.CustomUserPreferences = {
        NSGlobalDomain = {
          AppleActionOnDoubleClick = "Maximize";
        };
      };

      system.defaults.controlcenter.Sound = true;
      
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
      networking.computerName = "MacMini";
      networking.hostName = "MacMini";
}