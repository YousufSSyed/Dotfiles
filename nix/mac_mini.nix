{
  pkgs,
  inputs,
  hostName,
  ...
}:
{
  imports = [
    ./base.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
  ];

  _module.args = {
    firefoxProfile = "mac-profile";
    hostName = "Mac-Mini";
  };

  users.users.yousuf.home = "/Users/yousuf";

  environment.systemPackages = with pkgs; [
    syncthing-macos
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
      "music-decoy"
      "karabiner-elements"
      "espanso"
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
      NSAutomaticPeriodSubstitutionEnabled = false;
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
  launchd.user.agents = {
    watchexec = {
      command = "${pkgs.watchexec}/bin/watchexec -w /Users/yousuf/.local/share/chezmoi/ ${pkgs.chezmoi}/bin/chezmoi apply --force";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/Users/yousuf/Library/Logs/watchexec.log";
        EnvironmentVariables = {
          HOME = "/Users/yousuf";
        };
      };
    };
  };

  environment.etc."nsmb.conf".text = ''
    [default]
    streams=yes
    soft=yes
    mc_on=yes
    mc_prefer_wired=yes
    signing_required=no 
    comp_io_threshold=5242880
    mc_max_channels=64
    smb_neg=smb3_only
    port445=no_netbios
  '';

  environment.etc."nfs.conf".text = ''
    nfs.client.mount.options = vers=4.0
    nfs.client.allow_async = 1
    nfs.client.iosize = 268435456
    nfs.client.nfsiod_thread_max = 64
    nfs.client.access_cache_timeout = 120
  '';

  home-manager.users.yousuf.programs.firefox.profiles.default.settings = {
    "layout.css.devPixelsPerPx" = 2.15;
  };

  power.sleep.display = "never";

  # Misc device settings
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.computerName = hostName;
}
