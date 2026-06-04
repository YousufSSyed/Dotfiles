{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    iina
    syncthing-macos
  ];

  homebrew = {
    enable = true;
    casks = [
      "affinity"
      "betterdisplay"
    ];
  };

  # System settings
  system.primaryUser = "yousuf";
  system.defaults = {
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    dock.mineffect = "scale";
    dock.minimize-to-application = true;
    controlcenter.Sound = true;
    NSGlobalDomain.AppleShowAllFiles = true;
    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleActionOnDoubleClick = "Maximize";
      };
    };
  };

  # Launchd Configuration
  launchd.daemons = {
    copyparty = {
      command = "${pkgs.copyparty-most}/bin/copyparty -v /Users/yousuf::A --see-dots";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/log/copyparty.log";
        StandardErrorPath = "/var/log/copyparty.error.log";
      };
    };
    watchexec = {
      command = "${pkgs.watchexec}/bin/watchexec -w /Users/yousuf/.local/share/chezmoi/ ${pkgs.chezmoi}/bin/chezmoi apply --force";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/log/watchexec.log";
        StandardErrorPath = "/var/log/watchexec.error.log";
        EnvironmentVariables = {
          HOME = "/Users/yousuf";
        };
      };
    };
  };

  # Misc device settings
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.computerName = "MacMini";
  networking.hostName = "MacMini";
}