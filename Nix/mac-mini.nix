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
      "sf-symbols"
    ];
  };

  # System settings
  system.primaryUser = "yousuf";
  system.defaults = {
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    dock = {
      minimize-to-application = true;
      show-recents = false;
      wvous-br-corner = 1;
      mineffect = "scale";
      autohide = false;
      tilesize = 55;
    };
    finder = {
      FXEnableExtensionChangeWarning = false;
      AppleShowAllExtensions = true;
      FXDefaultSearchScope = "SCcf";
      AppleShowAllFiles = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file:///Users/yousuf/Downloads";
      QuitMenuItem = false;
      ShowExternalHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
      ShowPathbar = true;
    };
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
        EnvironmentVariables = {
          HOME = "/Users/yousuf";
        };
      };
    };
  };

  # Misc device settings
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.computerName = "Mac-Mini";
  networking.hostName = "Mac-Mini";
}

