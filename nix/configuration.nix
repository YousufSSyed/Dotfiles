{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  zen-profile = "3672jyyb.Default Profile";
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
    kitty
    neovide
    neovim
    fish
    obsidian
    activitywatch
    qview
    gparted
    # ulauncher
    font-manager
    qbittorrent
    megabasterd
    gimp3-with-plugins
    rofi
    ruffle
    virt-manager
    vivaldi
    lutris
    libuuid
    inkscape-with-extensions
    birdtray
    losslesscut-bin
    whisper-cpp
    nvitop
    vesktop
    blender
    (mpv-unwrapped.override {
      ffmpeg = ffmpeg-full;
    })
    davinci-resolve
    vscode
    nvitop
    diff-so-fancy
    delta
    kdePackages.kde-dev-utils

    freetype
    plasma-panel-colorizer

    # kdotool

    # winetricks
    # wineWow64Packages.wayland

    edk2
    libxcb

    # AI Tools
    code-cursor-fhs

    # Git tools
    github-desktop
    lazygit

    # Command Line Tools / CLIs
    uutils-coreutils-noprefix
    coreutils-prefixed
    gnumake
    fd
    fzf
    eza
    gcc
    cmake
    bat
    keyd
    zoxide
    ripgrep
    starship
    bottom
    yazi
    sd
    (ffmpeg-full.override {
      withUnfree = true;
    })
    pkg-config
    slurp
    lnav
    wl-clipboard
    jujutsu
    yt-dlp
    gallery-dl
    exiftool
    unzip
    imagemagick
    tesseract
    socat
    trashy
    age
    sops
    git-crypt
    btrfs-progs
    yq-go
    snapper
    jnv
    jq
    p7zip
    whois
    git-filter-repo
    tig
    atuin
    rofimoji
    hyprpicker
    pastel
    pciutils
    brightnessctl
    wget

    # Command Line Apps / CLI Apps
    wf-recorder
    grim
    dua
    quickshell

    # LSPs, Linters, and language Related Packages
    # Misc languages
    rust-analyzer
    markdown-oxide
    nixfmt
    nixd
    hyprls
    uv
    python315
    # Golang
    go
    gopls
    # Lua
    stylua
    lua-language-server
    # JS
    biome
    yarn
    nodejs

    # Misc Packages
    nerd-fonts.iosevka # Installed for nerd icons
    libinput-gestures
    apple-cursor
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
    widevine-cdm
    dconf
    swtpm
    # extra-cmake-modules

    # Flakes
    inputs.hyprland-contrib.packages.${stdenv.hostPlatform.system}.grimblast
    inputs.hyprland-contrib.packages.${stdenv.hostPlatform.system}.shellevents
    inputs.awww.packages.${stdenv.hostPlatform.system}.awww
    inputs.aw-hyprland.packages.${stdenv.hostPlatform.system}.aw-watcher-window-hyprland
    inputs.hyprfloat.packages.${stdenv.hostPlatform.system}.default

    # KDE Packages
    kdePackages.dolphin
    kdePackages.qtsvg
    libsForQt5.kservice
    kdePackages.plasma-systemmonitor
    # inputs.kwin-effects-better-blur-dx.packages.${stdenv.hostPlatform.system}.default
    inputs.kwin-effects-forceblur.packages.${stdenv.hostPlatform.system}.default
    # inputs.kwin-effects-glass.packages.${stdenv.hostPlatform.system}.default
    kdePackages.extra-cmake-modules

    linuxHeaders
    looking-glass-client

    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];

  systemd.user.timers."wallpaper" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "wallpaper.service";
      OnCalendar = "minutely";
      OnBootSec = "1s";
    };
  };
  systemd.user.services."wallpaper" = {
    script = ''
      /run/current-system/sw/bin/fish /home/yousuf/Assets/Scripts/wallpaper.fish
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "yousuf";
    };
  };

  ## Update flake inputs daily
  systemd.services = {
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

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  boot.supportedFilesystems = {
    exfat = true; # Provides exfat support for programs like GParted.
    btrfs = true; # Other filesystems added because I feel like it.
    ntfs = true;
  };

  # Allow local users to mount system disks
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ( subject.local && action.id == "org.freedesktop.udisks2.filesystem-mount-system") {
        return polkit.Result.YES; }});
  '';

  networking.firewall.trustedInterfaces = [ "virbr0" ];
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
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

  programs.nix-ld.libraries = [
    config.boot.kernelPackages.nvidia_x11
  ];

  # boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  # boot.initrd.kernelModules = [
  #   "kvmfr"
  # ];
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="kvmfr", OWNER="${config.users.users.yousuf.name}", GROUP="qemu-libvirtd", MODE="0600"
  # '';

  # virtualisation.libvirtd.qemu.verbatimConfig = ''
  #   cgroup_device_acl = [
  #       "/dev/null", "/dev/full", "/dev/zero",
  #       "/dev/random", "/dev/urandom",
  #       "/dev/ptmx", "/dev/kvm",
  #       "/dev/userfaultfd", "/dev/kvmfr0"
  #   ]
  # '';

  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
  '';

  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
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
    nix-ld.enable = true;
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
  };

  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.garnix.io"
      "https://cache.nixos-cuda.org"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://cache.garnix.io"
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
    trusted-users = [
      "@wheel"
      "yousuf"
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
    loader = {
      timeout = 0; # Disable the startup menu to select a nix config version.
      systemd-boot.enable = true;
    };
    # Silent boot
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = [
      "uinput"
      "vfio-iommu-type1"
      "vfio_pci"
      "vfio"
      "vfio_virqfd"
      # "mdev"
      # "vfio-mdev"

      "ddcci-driver"
    ];
    kernelParams = [
      "vfio-pci.ids=1002:13c0"
      # "vfio-pci.ids=1002:1640,1c5c:1327"
      "iommu=pt"
      "video=efifb:off"

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

  # boot.extraModprobeConfig = "options vfio-pci ids=1002:1640,1c5c:1327";
  boot.extraModprobeConfig = "options vfio-pci ids=1002:13c0";
  systemd.packages = [ pkgs.libinput-gestures ];
  # boot.blacklistedKernelModules = [ "amdgpu" ];

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
    overrides = {
      global = {
        Environment = {
          filesystems = [
            "/home" # Expose user Git config
          ];
        };
      };
    };
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
          inputs.zen-browser.homeModules.beta
          # inputs.zen-browser.homeModules.twilight
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
          file.".zen/${zen-profile}/chrome".source =
            config.lib.file.mkOutOfStoreSymlink "/home/yousuf/.config/userChrome";
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
        programs.zen-browser = {
          enable = true;
          profiles = {
            default = {
              id = 0;
              name = "Default";
              isDefault = true;
              path = zen-profile;
              settings = {
                "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
                "toolkit.legacyUserProfile.Customizations.stylesheets" = true;
                "browser.bookmarks.showMobileBookmarks" = true;
                # Open new tab next to current one instead of at the rightmost.
                browser.tabs.insertAfterCurrent = true;
                browser.tabs.insertRelatedAfterCurrent = true;
                "browser.gesture.swipe.up" = ""; # Disable swipe gestures
                "browser.gesture.swipe.down" = "";
                "browser.gesture.swipe.left" = "";
                "browser.gesture.swipe.right" = "";
                "apz.allow_double_tap_zooming" = false; # Don't double tap the trackpad to zoom in the page;
                "browser.tabs.closeWindowWithLastTab" = true;
                "browser.urlbar.showSearchTerms.featureGate" = true; # Show the search query in the URL bar instead of the URL (only for the default search engine).
                "xpinstall.signatures.required" = false; # Don't require signatures on addons to install them. Allows sideloading addons.
                "browser.tabs.loadBookmarksInTabs" = true; # Open bookmarks in new tabs instead of in the current one.
                "browser.urlbar.trimURLs" = false; # Show whole URLs in the URL bar.
                "devtools.debugger.remote-enabled" = true;
                "devtools.chrome.enabled" = true;
                "zen.theme.content-element-separation" = 0; # disable border around zen window
                "zen.tabs.close-on-back-with-no-history" = false;
                "zen.urlbar.replace-newtab" = false;
                # Attempt to make addons work in restricted domains
                "extensions.webextensions.restrictedDomains" = ""; # Don't restrict any domains from addons
                "extensions.quarantinedDomains.enabled" = false;
                "privacy.resistFingerprinting.block_mozAddonManager" = true;
                "accessibility.typeaheadfind.manual" = false; # Disable pressing "/" key for quick find
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
        programs.mpv = {
          enable = true;
          package = (
            pkgs.mpv-unwrapped.override {
              ffmpeg = pkgs.ffmpeg-full;
            }
          );
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

  programs.bash.shellInit = ''
    		export GRIMBLAST_HIDE_CURSOR=0
    		export SOPS_AGE_KEY_FILE="/home/yousuf/Assets/sops/age/keys.txt"
    		export SLURP_ARGS="-B 00000000 -b 00000000 -c 80808080 -w 2"
    		export MANPAGER="nvim +Man!"
    		export EDITOR="nvim"
    		export ELECTRON_OZONE_PLATFORM_HINT=auto
  '';

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
    optimise.automatic = true; # Nix optimizations
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "SF Pro Display" ];
        # serif = [ "SF Pro Text" ];
        monospace = [ "Iosevka Custom" ];
        emoji = [ "Apple Color Emoji" ];
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
    ];
    hashedPasswordFile = config.sops.secrets.YOUSUFS_PASSWORD.path;
  };

  virtualisation.docker = {
    enable = true;
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
    # Desktop Services
    desktopManager.plasma6.enable = true;
    displayManager = {
      # defaultSession = "hyprland-uwsm";
      defaultSession = "plasma";
      autoLogin.user = "yousuf";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    # System services
    pipewire.enable = true;
    gvfs.enable = true; # Enables reading external drives
    udisks2.enable = true; # Enables reading external drives
    automatic-timezoned.enable = true;
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
    };
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };

  usbmuxd = {
    # Used
    enable = true;
    package = pkgs.usbmuxd2;
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024;
    }
  ];

  time.hardwareClockInLocalTime = true;
  system.stateVersion = "25.11";
}
