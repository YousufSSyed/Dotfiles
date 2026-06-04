{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  firefox-profile = "h9ep31cd.default";
  sans-serif-font = "SF Pro Display";
  monospace-font = "Iosevka Custom";
  emoji-font = "Apple Color Emoji";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
  ];

  # Packages
  nixpkgs = {
    config = {
      cudaSupport = true;
      allowUnfree = true;
    };
    overlays = [
      inputs.dolphin-overlay.overlays.default
    ];
  };

  environment.systemPackages = with pkgs; [
    # Apps
    gparted
    # ulauncher
    font-manager
    vivaldi
    birdtray
    rofi
    obsidian
    losslesscut-bin
    nvitop
    vesktop
    davinci-resolve
    kdePackages.kde-dev-utils
    plasma-panel-colorizer
    # kdotool

    # Command Line Tools / CLIs
    keyd
    trashy
    btrfs-progs
    compsize
    rofimoji
    hyprpicker

    discordchatexporter-desktop

    # Command Line Apps / CLI Apps
    wf-recorder
    grim
    quickshell

    # Misc Packages
    libinput-gestures
    apple-cursor
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
    widevine-cdm
    ddcutil

    # extra-cmake-modules

    # Flakes
    inputs.hyprland-contrib.packages.${stdenv.hostPlatform.system}.grimblast
    inputs.hyprland-contrib.packages.${stdenv.hostPlatform.system}.shellevents
    inputs.awww.packages.${stdenv.hostPlatform.system}.awww
    inputs.aw-hyprland.packages.${stdenv.hostPlatform.system}.aw-watcher-window-hyprland
    inputs.hyprfloat.packages.${stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".twilight

    # KDE Packages
    kdePackages.dolphin
    kdePackages.qtsvg
    libsForQt5.kservice
    kdePackages.plasma-systemmonitor
    inputs.kwin-effects-better-blur-dx.packages.${stdenv.hostPlatform.system}.default
    inputs.kwin-effects-glass.packages.${stdenv.hostPlatform.system}.default
    kdePackages.extra-cmake-modules
  ];

  systemd = {
    packages = [ pkgs.libinput-gestures ];
    # Systemd Timers
    user.timers."wallpaper" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "wallpaper.service";
        OnCalendar = "minutely";
        OnBootSec = "1s";
      };
    };
    user.services."wallpaper" = {
      script = ''
        /run/current-system/sw/bin/fish /home/yousuf/Assets/Scripts/wallpaper.fish
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "yousuf";
      };
    };
    # Systemd services
    # Update flake inputs daily
    services = {
      flake-update = {
        preStart = "/run/current-system/sw/bin/nm-online";
        unitConfig = {
          Description = "Update flake inputs";
          StartLimitIntervalSec = 300;
          StartLimitBurst = 5;
        };
        serviceConfig = {
          ExecStart = "${pkgs.nix}/bin/nix flake update --flake /home/yousuf/.config/nix";
          Restart = "on-failure";
          RestartSec = "30";
          Type = "oneshot"; # Ensure that it finishes before starting nixos-upgrade
          User = "yousuf";
        };
        before = [ "nixos-upgrade.service" ];
        path = [
          pkgs.nix
          pkgs.git
          pkgs.host
        ];
      };
    };
  };

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

  hardware = {
    i2c.enable = true;
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = true;
      open = true;
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "path:///home/yousuf/.config/nix";
    flags = [ "-L" ];
    dates = "0:00";
    randomizedDelaySec = "45min";
  };

  programs = {
    ydotool.enable = true;
    git.enable = true;
    mtr.enable = true;
    firefox.enable = true;
    firefox.autoConfig = builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
        sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
      }
    );
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # Hyprland config
    hyprland = {
      withUWSM = true;
      enable = true;
    };
    hyprlock.enable = true;
    uwsm.enable = true;
    uwsm.waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/start-hyprland";
      };
    };
    # Nix-ld
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        config.boot.kernelPackages.nvidia_x11
        # ComfyUI packages
        libxcb
        libX11
        libXext
        libXrender
        libGL
        libGLU
        glib
        stdenv.cc.cc.lib
      ];
    };
    # Global Environment Variables
    bash.shellInit = ''
      	export GRIMBLAST_HIDE_CURSOR=0
      	export SOPS_AGE_KEY_FILE="/home/yousuf/Assets/sops/age/keys.txt"
      	export SLURP_ARGS="-B 00000000 -b 00000000 -c 80808080 -w 2"
      	export MANPAGER="nvim +Man!"
      	export EDITOR="nvim"
      	export HOUR="5"
      	# awaiting patch for triton to remove this: https://github.com/NixOS/nixpkgs/issues/426296
      	export TRITON_LIBCUDA_PATH=/run/opengl-driver/lib
    '';
  };

  nix.settings = {
    download-buffer-size = 524288000; # 500 MiB
    trusted-users = [
      "@wheel"
      "yousuf"
    ];
    # Cache substitutes
    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };

  services.hypridle.enable = true;

  environment.etc."keyd/default.conf".text = ''
    		[ids]
    		046d:c24d:f7b1be65
    		046d:c24d:61c4abd0
    		2333:6666:69419150
    		0000:0006:bdb72f48
    		0000:0000:faf03c86

    		[main]
    		capslock = esc
    		leftshift = capslock
    		leftmeta = leftalt
    		leftalt  = leftcontrol
    		rightalt = leftshift
    		rightsuper = leftmeta

    		[control]
    		backspace = delete

    		[meta]
    		h = left
    		j = down
    		k = up
    		l = right

    		[alt+meta]
    		h = C-pageup
    		l = C-pagedown

    		[control+meta]
    		h = C-[
    		l = C-]
  '';

  boot = {
    supportedFilesystems = {
      exfat = true;
      btrfs = true;
      ntfs = true;
      nfs = true;
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0; # Disable the startup menu to select a nix config version.
    };
    # Silent boot
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = [ "uinput" ];
    kernelParams = [
      # Zswap
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=200"
      "zswap.shrinker_enabled=1"
      # Silent boot parameters
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
  };

  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    packages = [
      "com.github.tchx84.Flatseal"
      "eu.betterbird.Betterbird"
      "org.vinegarhq.Sober"
      "org.vinegarhq.Vinegar"
    ];
    overrides.global.Environment.filesystems = [
      "/home" # Expose user Git config
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    backupFileExtension = "backup";
    users.yousuf =
      {
        config,
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [
        ];
        home = {
          stateVersion = "25.11";
          pointerCursor = {
            gtk.enable = true;
            package = pkgs.apple-cursor;
            name = "macOS";
            size = 22;
            x11.enable = true;
            x11.defaultCursor = "macOS";
          };
          file.".local/share/fonts".source = config.lib.file.mkOutOfStoreSymlink "/home/yousuf/Assets/Fonts/";
          # file.".mozilla/firefox/${firefox-profile}/chrome".source =
          #   config.lib.file.mkOutOfStoreSymlink "/home/yousuf/.config/userChrome";
        };
        # xdg.desktopEntries = {
        #   neovide = {
        #     name = "Neovide";
        #     exec = "neovide";
        #     icon = "/home/yousuf/Assets/Icons/5caff61e599cf84c05a7b9744fafe47b_Neovim_1024x1024x32.png";
        #   };
        #   zen = {
        #     name = "Zen Browser (Beta)";
        #     exec = "zen-twilight --name zen-beta %U";
        #     icon = "/home/yousuf/Assets/Icons/24ecc308297f3cd5d09791c67609837a_Firefox_1024x1024x32.png";
        #   };
        #   kitty = {
        #     name = "kitty";
        #     exec = "kitty";
        #     icon = "/home/yousuf/Assets/Icons/06bbe8009cf7de155c6fa1e832778ff9_Ghostty_1024x1024x32.png";
        #   };
        #   obsidian = {
        #     name = "Obsidian";
        #     exec = "obsidian %u";
        #     icon = "/home/yousuf/Assets/Icons/391eacacb0418bb1536a56c8be8f003a_1761532027448_1024x1024x32.png";
        #   };
        #   dolphin = {
        #     name = "dolphin";
        #     exec = "dolphin %u";
        #     icon = "/home/yousuf/Assets/Icons/584b5505aefd428082f1ab3d9f8fa609_Files_1024x1024x32.png";
        #   };
        # };
        programs.firefox = {
          enable = true;
          profiles = {
            default = {
              id = 0;
              name = "Default";
              isDefault = true;
              path = firefox-profile;
              # Firefox settings in about:config
              settings = {
                # Misc Settings
                "xpinstall.signatures.required" = false; # Don't require signatures on addons to install them. Allows sideloading addons.
                "accessibility.typeaheadfind.manual" = false; # Disable pressing "/" key for quick find
                "toolkit.legacyUserProfile.Customizations.stylesheets" = true;
                "font.name-list.emoji" = emoji-font;
                "ui.key.menuAccessKey" = 0; # Disable Alt + B from opening Menu bar
                "apz.allow_double_tap_zooming" = false; # Don't double tap the trackpad to zoom in the page;
                "dom.forms.autocomplete.formautofill" = false;
                "intl.date_time.pattern_override.time_short" = "h:mm a";
                "network.http.max-connections" = 1500;
                "network.http.max-persistent-connections-per-server" = 64;
                "browser.gesture.swipe.up" = "";
                "browser.gesture.swipe.down" = "";
                "browser.gesture.swipe.left" = "";
                "browser.gesture.swipe.right" = "";
                "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
                "browser.bookmarks.showMobileBookmarks" = true;
                "browser.aboutConfig.showWarning" = false;
                "browser.urlbar.showSearchTerms.featureGate" = true; # Show the search query in the URL bar instead of the URL (only for the default search engine).
                "browser.urlbar.trimURLs" = false; # Show whole URLs in the URL bar.
                "browser.tabs.closeWindowWithLastTab" = true;
                "browser.tabs.loadBookmarksInTabs" = true; # Open bookmarks in new tabs instead of in the current one.
                # Open new tab next to current one instead of at the rightmost.
                "browser.tabs.insertAfterCurrent" = true;
                "browser.tabs.insertRelatedAfterCurrent" = true;

                # Dev tools
                "devtools.debugger.remote-enabled" = true;
                "devtools.chrome.enabled" = true;
                "devtools.inspector.three-pane-enabled" = false;

                # Attempt to make addons work in restricted domains
                "extensions.webextensions.restrictedDomains" = "";
                "extensions.quarantinedDomains.enabled" = false;
                "privacy.resistFingerprinting.block_mozAddonManager" = true;

                # Right click menu
                "browser.ml.linkPreview.enabled" = false;
                "devtools.accessibility.enabled" = false;
                "extensions.formautofill.creditCards.enabled" = false;
                "privacy.query_stripping.strip_on_share.enabled" = false;
                "browser.ml.chat.enabled" = false;
                "browser.ml.chat.menu" = false;
                "browser.search.visualSearch.featureGate" = false;

                # Zen Browser specific options:
                "zen.theme.content-element-separation" = 0; # disable border around zen window
                "zen.tabs.close-on-back-with-no-history" = false;
                "zen.urlbar.replace-newtab" = false;
              };
            };
            secondary = {
              id = 1;
              name = "Secondary";
              path = "o9fiaukr.2nd Profile";
            };
          };
          nativeMessagingHosts = [ pkgs.firefoxpwa ];
        };
        programs.thunderbird = {
          enable = true;
          profiles."dexxqztk.Default User" = {
            isDefault = true;
            # path = "dexxqztk.Default User";
            settings = {
              "mail.minimizeToTray.startMinimized" = true;
              "mail.biff.show_tray_icon_always" = true;
              "mail.minimizeToTray.supportedDesktops" = "kde,gnome,pop:gnome,xfce,mate,hyprland";
            };
          };
        };
        services.darkman = {
          enable = true;
          lightModeScripts.gtk-theme = ''
            ${pkgs.dconf}/bin/dconf write \
                /org/gnome/desktop/interface/color-scheme "'prefer-light'"
          '';
          darkModeScripts.gtk-theme = ''
            ${pkgs.dconf}/bin/dconf write \
                /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
          '';
          settings = {
            lat = 42.3;
            long = -71.1;
            usegeoclue = true;
            dbusserver = true;
            portal = true;
          };
        };
      };
  };

  services.avahi.enable = true;
  services.geoclue2.enable = true;
  services.geoclue2.submitData = true;
  services.geoclue2.enableWifi = false;
  services.geoclue2.enableDemoAgent = lib.mkForce true;

  sops = {
    age.keyFile = "/home/yousuf/Assets/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets.YOUSUFS_PASSWORD.neededForUsers = true;
    secrets.NEXTAUTH_SECRET.owner = config.services.linkwarden.user;
  };

  networking = {
    hostName = "NixOS-Desktop";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise = {
      persistent = true;
      automatic = true;
    };
    gc = {
      options = "--delete-older-than 7d";
      dates = "weekly";
      automatic = true;
    };
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        sansSerif = [ sans-serif-font ];
        monospace = [ monospace-font ];
        emoji = [ emoji-font ];
      };
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
        <fontconfig>
          <match>
            <test name="family">
              <string>sans-serif</string>
            </test>
            <edit name="weight" mode="assign">
              <const>medium</const>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  services.tailscale.enable = true;

  users.users.yousuf = {
    isNormalUser = true;
    home = "/home/yousuf";
    hashedPasswordFile = config.sops.secrets.YOUSUFS_PASSWORD.path;
    extraGroups = [
      "networkmanager"
      "wheel"
      "keyd"
      "input"
      "ydotool"
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
      "i2c"
      "docker"
      "storage"
    ];
  };

  virtualisation.docker = {
    enable = true;
  };

  security.polkit.extraConfig = ''
      /* Allow local users to mount system disks */
      polkit.addRule(function(action, subject) {
        if ( subject.local && action.id == "org.freedesktop.udisks2.filesystem-mount-system") {
          return polkit.Result.YES;
        }
    });
  '';

  services = {
    # App services
    keyd.enable = true;
    atuin.enable = true;
    libinput.enable = true;
    espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };
    # Desktop Services
    desktopManager.plasma6.enable = true;
    displayManager = {
      # defaultSession = "hyprland-uwsm";
      defaultSession = "plasma";
      autoLogin.user = "yousuf";
      plasma-login-manager.enable = true;
    };
    # System services
    pipewire.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    automatic-timezoned.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
    # Filesystem services
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
    beesd.filesystems = {
      root = {
        spec = "LABEL=root";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "5.0"
        ];
      };
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32 * 1024;
    }
  ];

  system.stateVersion = "25.11";
}
