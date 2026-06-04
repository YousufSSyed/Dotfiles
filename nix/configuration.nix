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
    # inputs.hyprland.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  # Packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.dolphin-overlay.overlays.default
  ];
  environment.systemPackages = [
    # Apps
    pkgs.kitty
    pkgs.neovide
    pkgs.neovim
    pkgs.fish
    pkgs.obsidian
    pkgs.activitywatch
    pkgs.waybar
    pkgs.qview
    pkgs.gparted
    # pkgs.ulauncher
    pkgs.font-manager
    # pkgs.dissent
    pkgs.qbittorrent
    pkgs.megabasterd
    pkgs.gimp3-with-plugins
    pkgs.github-desktop
    pkgs.rofi
    pkgs.ruffle
    pkgs.hyprshade
    pkgs.virt-manager
    pkgs.vivaldi
    pkgs.lutris
    pkgs.libuuid
    pkgs.edk2

    pkgs.winetricks
    pkgs.wineWow64Packages.wayland

    # Command Line Tools / CLIs
    pkgs.coreutils-prefixed
    pkgs.uutils-coreutils-noprefix
    pkgs.gnumake
    pkgs.fd
    pkgs.fzf
    pkgs.eza
    pkgs.gcc
    pkgs.cmake
    pkgs.bat
    pkgs.keyd
    pkgs.zoxide
    pkgs.ripgrep
    pkgs.starship
    pkgs.bottom
    pkgs.yazi
    pkgs.sd
    pkgs.nsxiv
    pkgs.ffmpeg-full
    pkgs.pkg-config
    pkgs.slurp
    pkgs.killall
    pkgs.lnav
    pkgs.wl-clipboard
    pkgs.jujutsu
    pkgs.yt-dlp
    pkgs.gallery-dl
    pkgs.exiftool
    pkgs.sunpaper
    pkgs.wallutils
    pkgs.unzip
    pkgs.imagemagick
    pkgs.tesseract
    pkgs.socat
    pkgs.trashy
    pkgs.age
    pkgs.sops
    pkgs.git-crypt
    pkgs.btrfs-progs
    pkgs.yq-go
    pkgs.snapper
    pkgs.jnv
    pkgs.jq
    pkgs.p7zip
    pkgs.whois
    pkgs.git-filter-repo
    pkgs.tig
    pkgs.atuin
    pkgs.rofimoji
    pkgs.hyprpicker
    pkgs.pastel
    pkgs.pciutils
    pkgs.brightnessctl
    pkgs.uv

    # Command Line Apps / CLI Apps
    pkgs.wf-recorder
    pkgs.grim
    pkgs.dua

    # LSPs, Linters, and languages
    pkgs.go
    pkgs.stylua
    pkgs.lua-language-server
    pkgs.gopls
    pkgs.rust-analyzer
    pkgs.markdown-oxide
    pkgs.nixfmt-rfc-style
    pkgs.nixd
    pkgs.hyprls

    # Misc Packages
    pkgs.nerd-fonts.iosevka # Installed for nerd icons
    pkgs.libinput-gestures
    pkgs.apple-cursor
    pkgs.sunwait
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal
    pkgs.widevine-cdm
    pkgs.dconf
    pkgs.vesktop

    # Flakes
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.hyprshell.packages.${pkgs.stdenv.hostPlatform.system}.hyprshell
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.hdrop
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.shellevents
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    inputs.aw-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.aw-watcher-window-hyprland
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default

    # inputs.youtube-tui.packages.${pkgs.stdenv.hostPlatform.system}.youtube-tui
    pkgs.youtube-tui

    # KDE Packages
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.qtsvg
    pkgs.haruna
    pkgs.libsForQt5.kservice

    pkgs.linuxHeaders
    pkgs.looking-glass-client
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
        ExecStart = "${pkgs.nix}/bin/nix flake update --flake ${inputs.self.outPath}";
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

  services.invidious = {
    enable = true;
    port = 3001;
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

  programs.nix-ld.libraries = [ config.boot.kernelPackages.nvidia_x11 ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
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
    nix-ld.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # Hyprland config
    hyprland = {
      withUWSM = true;
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage =
      #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    hyprlock.enable = true;
    uwsm.enable = true;
    uwsm.waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  # nix.settings = {
  #   substituters = [
  #     "https://hyprland.cachix.org"
  #     "https://cache.garnix.io"
  #   ];
  #   trusted-substituters = [
  #     "https://hyprland.cachix.org"
  #     "https://cache.garnix.io"
  #   ];
  #   trusted-public-keys = [
  #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #     "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  #   ];
  #   trusted-users = [
  #     "@wheel"
  #     "yousuf"
  #   ];
  # };

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
      # "kvmgt"
      # "vfio-mdev"

      "ddcci-driver"
    ];
    kernelParams = [
      "intel_iommu=on"
      "vfio-pci.ids=8086:3e98"
      # "i915.enable_gvt=1"
      # "i915.enable_guc=0"
      "iommu=pt"

      # Zswap
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=100"
      # Silent boot parameters
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
  };

  boot.extraModprobeConfig = "options vfio-pci ids=8086:3e98";
  systemd.packages = [ pkgs.libinput-gestures ];

  services.flatpak.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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
          inputs.zen-browser.homeModules.twilight
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
              };
            };
            secondary = {
              id = 1;
              name = "Secondary";
              path = "o9fiaukr.2nd Profile";
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
  '';

  networking = {
    hostName = "NixOS-Desktop"; # Computer Name
    networkmanager.enable = true;
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
    keyd.enable = true;
    atuin.enable = true;
    libinput.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "hyprland-uwsm";
      autoLogin.user = "yousuf";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
    };
    gvfs.enable = true; # Enables reading external drives
    udisks2.enable = true; # Enables reading external drives
    automatic-timezoned.enable = true;
    pipewire.enable = true;
    espanso = {
      enable = false;
      package = pkgs.espanso-wayland;
    };
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };

  time.hardwareClockInLocalTime = true;
  system.stateVersion = "25.11";
}
