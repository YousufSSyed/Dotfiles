{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  sans-serif-font = "SF Pro Display";
  monospace-font = "Iosevka Custom";
  emoji-font = "Apple Color Emoji";
in
{
  imports = [
    ./home.nix
    ./base.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.default
  ];

  # Packages
  environment = {
    systemPackages = with pkgs; [
      # Apps
      gparted
      # ulauncher
      font-manager
      vivaldi
      # birdtray
      rofi
      obsidian
      nvitop
      vesktop
      davinci-resolve
      kdePackages.kde-dev-utils
      plasma-panel-colorizer
      # activitywatch
      # kdotool
      libreoffice
      qview
      mousai
      proton-vpn
      proton-vpn-cli

      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

      rustdesk-flutter

      # Command Line Tools / CLIs
      keyd
      trashy
      rofimoji
      hyprpicker
      snapper
      wl-clipboard
      slurp

      discordchatexporter-desktop

      # Command Line Apps / CLI Apps
      wf-recorder
      grim
      quickshell
      (ffmpeg-full.override {
        withUnfree = true;
      })

      # Misc Packages
      libinput-gestures
      apple-cursor
      xdg-desktop-portal-hyprland
      xdg-desktop-portal
      widevine-cdm
      ddcutil
      libnotify

      # Flakes
      inputs.hyprland-contrib.packages.${stdenv.hostPlatform.system}.grimblast
      inputs.hyprland-contrib.packages.${stdenv.hostPlatform.system}.shellevents
      inputs.awww.packages.${stdenv.hostPlatform.system}.awww
      inputs.aw-hyprland.packages.${stdenv.hostPlatform.system}.aw-watcher-window-hyprland
      inputs.hyprfloat.packages.${stdenv.hostPlatform.system}.default

      # KDE Packages
      inputs.kwin-effects-better-blur-dx.packages.${stdenv.hostPlatform.system}.default
      # inputs.kwin-effects-glass.packages.${stdenv.hostPlatform.system}.default
      kdePackages.extra-cmake-modules

      # System Tools
      btrfs-progs
      compsize
    ];
    variables = {
      GRIMBLAST_HIDE_CURSOR = "0";
      SOPS_AGE_KEY_FILE = "/home/yousuf/Sync/Misc/age-keys.txt";
      SLURP_ARGS = "-B 00000000 -b 00000000 -c 80808080 -w 2";
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      HOUR = "5";
      TRITON_LIBCUDA_PATH = "/run/opengl-driver/lib"; # awaiting patch for triton to remove this: https://github.com/NixOS/nixpkgs/issues/426296
      PYTHON_HISTORY = "/home/yousuf/.local/share/python/history";
      PSQL_HISTORY = "/home/yousuf/.local/share/.psql_history";
      GTK2_RC_FILES = "/home/yousuf/.config/gtkrc-2.0";
      TRITON_CACHE_DIR = "/home/yousuf/.local/share/triton/";
      GIT_CONFIG_GLOBAL = "/home/yousuf/.config/.gitconfig";
    };
  };

  system.autoUpgrade = {
    # in-progress PR for autoupgrade on darwin: https://github.com/nix-darwin/nix-darwin/pull/1682
    enable = true;
    flags = [ "--print-build-logs" ];
    flake = "path:///home/yousuf/.local/share/chezmoi";
  };

  systemd = {
    packages = [ pkgs.libinput-gestures ];
    # user.timers."wallpaper" = {
    #   wantedBy = [ "timers.target" ];
    #   timerConfig = {
    #     Unit = "wallpaper.service";
    #     OnCalendar = "minutely";
    #     OnBootSec = "1s";
    #   };
    # };
    user.services = {
      "mac-mounting" = {
        serviceConfig = {
          ExecStartPre = "${pkgs.uutils-coreutils-noprefix}/bin/mkdir -p /home/yousuf/Mac/";
          ExecStart = "${pkgs.rclone}/bin/rclone mount --config /home/yousuf/.config/rclone/rclone.conf --vfs-cache-mode writes --dir-cache-time 5s MacMini-dav: /home/yousuf/Mac/";
          ExecStop = "${pkgs.fuse}/bin/fusermount -uz /home/yousuf/Mac/";
          Type = "oneshot";
          User = "yousuf";
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        };
        wantedBy = [ "default.target" ];
      };
      "dotfiles" = {
        script = "${pkgs.watchexec}/bin/watchexec -w /home/yousuf/.local/share/chezmoi/ ${pkgs.chezmoi}/bin/chezmoi apply --force";
        serviceConfig = {
          Type = "oneshot";
          User = "yousuf";
        };
        wantedBy = [ "default.target" ];
      };
      "copyparty" = {
        serviceConfig = {
          ExecStartPre = "-${pkgs.udisks}/bin/udisksctl mount -b /dev/nvme0n1p4";
          ExecStart = "${pkgs.copyparty-most}/bin/copyparty -v /home/yousuf::A --see-dots";
          ExecStop = "${pkgs.udisks}/bin/udisksctl unmount -b /dev/nvme0n1p4";
          Type = "oneshot";
          User = "yousuf";
        };
        wantedBy = [ "default.target" ];
      };
      "wallpaper" = {
        wantedBy = lib.mkForce [ ];
        script = "${pkgs.fish}/bin/fish /home/yousuf/.local/share/chezmoi/scripts/wallpaper_cycle.fish";
        serviceConfig = {
          Type = "oneshot";
          User = "yousuf";
        };
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
    i2c.enable = true;
    nvidia = {
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      open = true;
    };
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    ydotool.enable = true;
    firefox = {
      enable = true;
      autoConfig = builtins.readFile (
        builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        }
      );
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--optimise";
      flake = "/home/yousuf/.local/share/chezmoi";
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
  };

  nix.settings = {
    download-buffer-size = 524288000;
    trusted-users = [
      "@wheel"
      "yousuf"
    ];
    # Cache substitutes
    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
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
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs"
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
            0b05:19b6:9e0e30a6

            [main]
            capslock = esc
            leftshift = capslock
            leftmeta = leftalt
            leftalt  = leftcontrol
            rightalt = leftshift
            rightsuper = leftmeta
        		rightcontrol = leftmeta
    				

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
      timeout = 0;
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
      "re.fossplant.songrec"
      "org.vinegarhq.Sober"
    ];
  };

  home-manager = {
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    users.yousuf =
      {
        config,
        pkgs,
        ...
      }:
      {
        home = {
          file.".local/share/fonts".source = config.lib.file.mkOutOfStoreSymlink "/home/yousuf/Sync/Fonts/";
          pointerCursor = {
            gtk.enable = true;
            package = pkgs.apple-cursor;
            name = "macOS";
            size = 22;
            x11.enable = true;
            x11.defaultCursor = "macOS";
          };
        };
        services.darkman = {
          enable = false;
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
            usegeoclue = false;
            dbusserver = true;
            portal = true;
          };
        };
      };
  };

  sops = {
    age.keyFile = "/home/yousuf/Sync/Misc/age-keys.txt";
    defaultSopsFile = ./Other/secrets.yaml;
    secrets.YOUSUFS_PASSWORD.neededForUsers = true;
  };

  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = [ pkgs.nerd-fonts.martian-mono ];
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
      "i2c"
      "docker"
    ];
  };

  virtualisation.docker = {
    enable = true;
  };

  security = {
    sudo-rs.enable = true;
    polkit.extraConfig = ''
        /* Allow local users to mount system disks */
        polkit.addRule(function(action, subject) {
          if ( subject.local && action.id == "org.freedesktop.udisks2.filesystem-mount-system") {
            return polkit.Result.YES;
          }
      });
    '';
  };

  services = {
    # App services
    keyd.enable = true;
    atuin.enable = true;
    libinput.enable = true;
    espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };
    hardware.openrgb.enable = true;
    tailscale.enable = true;
    syncthing = {
      enable = true;
      user = "yousuf";
      dataDir = "/home/yousuf/.config/syncthing";
      configDir = "/home/yousuf/.config/syncthing/.config";
    };
    # Desktop Services
    desktopManager.plasma6.enable = true;
    displayManager = {
      # defaultSession = "hyprland-uwsm";
      # sddm.enable = true;
      defaultSession = "plasma";
      plasma-login-manager.enable = true;
      autoLogin.user = "yousuf";
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

  system.stateVersion = "26.05";
  nixpkgs.config.cudaSupport = true;
}
