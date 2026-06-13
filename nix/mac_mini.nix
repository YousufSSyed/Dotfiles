{
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    ./base.nix
    ./home.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
  ];

  users.users.yousuf.home = "/Users/yousuf";

  environment.systemPackages = with pkgs; [
    syncthing-macos
    karabiner-elements
    espanso
  ];

  homebrew = {
    enable = true;
    casks = [
      "affinity"
      "sf-symbols"
      "vivaldi"
      "the-unarchiver"
      "rustdesk"
      "protonvpn"
      "obsidian"
      "ddcctl"
      "waydabber/betterdisplay/betterdisplaycli"
    ];
  };

  # System settings
  system.primaryUser = "yousuf";
  system.defaults = {
    controlcenter.Sound = true;
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
    };
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      ApplePressAndHoldEnabled = false;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 4;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleActionOnDoubleClick = "Maximize";
      };
    };
  };

  # Launchd Configuration
  launchd.daemons = {
    copyparty = {
      command = "${pkgs.copyparty-most}/bin/copyparty -v /Users/yousuf::A -v /Volumes/Secondary/:/Secondary:A --see-dots";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
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

  home-manager.users.yousuf.programs.firefox.profiles.default.settings = {
    "layout.css.devPixelsPerPx" = 2.15;
  };

  power.sleep.display = "never";

  # Misc device settings
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.computerName = "Mac-Mini";
  networking.hostName = "Mac-Mini";
}
