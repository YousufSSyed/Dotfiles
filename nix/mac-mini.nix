{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
      environment.systemPackages =
      [ 
          pkgs.vim
      ];

      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

      networking.computerName = "MacMini";
      networking.hostName = "MacMini";

      system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
      system.defaults.dock.mineffect = "scale";
      system.defaults.dock.minimize-to-application = true;

      system.defaults.CustomUserPreferences = {
        NSGlobalDomain = {
          AppleActionOnDoubleClick = "Maximize";
        };
      };

      system.defaults.controlcenter.Sound = true;
      system.defaults.NSGlobalDomain.NSStatusItemSelectionPadding = 4;
      system.defaults.NSGlobalDomain.NSStatusItemSpacing = 4;

      programs.zsh.enable = true; 
    };