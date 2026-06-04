{
  config,
  lib,
  pkgs,
  flake-inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ flake-inputs.rust-overlay.overlays.default ];
  environment.systemPackages = with pkgs; [
    # Apps
    pkgs.kitty
    pkgs.neovide
    pkgs.obsidian
    pkgs.activitywatch
    pkgs.waybar
    pkgs.nwg-dock-hyprland
    pkgs.qview
    pkgs.ulauncher
    pkgs.font-manager
    pkgs.dissent
    pkgs.qbittorrent
    pkgs.swaylock
    pkgs.megabasterd
    pkgs.ulauncher
    pkgs.gimp3-with-plugins
    pkgs.github-desktop

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
    pkgs.wlrctl
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
    pkgs.hyprpaper
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
    pkgs.brightnessctl
    pkgs.apple-cursor
    pkgs.timewall
    pkgs.sunwait
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal
    pkgs.hyprpanel

    # Flakes
    flake-inputs.zen-browser.packages.${pkgs.system}.default
    flake-inputs.hyprshell.packages.aarch64-linux.hyprshell
    flake-inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    flake-inputs.hyprland-contrib.packages.${pkgs.system}.hdrop
    flake-inputs.hyprland-contrib.packages.${pkgs.system}.shellevents
    # flake-inputs.swww.packages.${pkgs.system}.swww
    # pkgs.swww
    pkgs.rust-bin.stable.latest.default

    # Temp Packages
    pkgs.jnv
    pkgs.jq
    pkgs.jaq
    pkgs.yq

    # KDE Packages
    kdePackages.dolphin
    kdePackages.qtsvg
    pkgs.haruna
    pkgs.libsForQt5.kservice
  ];

  services.hypridle.enable = true;

  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  system.autoUpgrade = {
    enable = true;
    flake = flake-inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "0:00";
    randomizedDelaySec = "45min";
  };

  programs = {
    hyprlock.enable = true;
    ydotool.enable = true;
    neovim.enable = true;
    yazi.enable = true;
    uwsm.enable = true;
    uwsm.waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
    hyprland.withUWSM = true;
    hyprland.enable = true;
    git.enable = true;
    fish.enable = true;
    firefox.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.etc."keyd/default.conf".text = ''
    [ids]
    05ac:0343:38ab045b

    [main]
    capslock = esc
    leftshift = capslock
    leftmeta = leftcontrol
    rightmeta = rightshift
    rightalt = leftmeta

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

  environment = {
    sessionVariables = rec {
      GRIMBLAST_HIDE_CURSOR = 0;
      SOPS_AGE_KEY_FILE = "/home/yousuf/Assets/sops/age/keys.txt";
      SLURP_ARGS = "-B 00000000 -b 00000000 -c 80808080 -w 2";
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
    };
    # Makes keyd work
    etc = {
      "libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
        [Serial Keyboards]
        MatchUdevType=keyboard
        MatchName=keyd virtual keyboard
        AttrKeyboardIntegration=internal
      '';
    };
  };

  boot = {
    loader = {
      timeout = 0; # Disable the startup menu to select a nix config version.
      efi.canTouchEfiVariables = false; # Needed for Asahi Nix.
      systemd-boot.enable = true;
    };
    # Silent boot
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = [ "uinput" ];
    kernelParams = [
      "apple_dcp.show_notch=1" # Allow using the space around the notch
      # Zswap
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=75"
      # Silent boot parameters
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
  };

  home-manager.users.yousuf =
    { config, ... }:
    {
      home = {
        stateVersion = "25.05";
        pointerCursor = {
          gtk.enable = true;
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 22;
          x11.enable = true;
          x11.defaultCursor = "macOS";
        };
      };
    };

  sops = {
    age.keyFile = "/home/yousuf/Assets/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets.OBSIDIAN_REST_API_KEY.owner = config.users.users.yousuf.name;
    secrets.YOUSUFS_PASSWORD.neededForUsers = true;
  };

  programs.bash.shellInit = ''
    export OBSIDIAN_REST_API_KEY="$(cat ${config.sops.secrets.OBSIDIAN_REST_API_KEY.path})"
  '';

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "NixOS-MBP"; # Computer Name
    networkmanager.enable = true;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  nix.optimise.automatic = true; # Nix optimizations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      (pkgs.callPackage ./Fonts.nix { })
    ];
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

  users.users = {
    yousuf = {
      isNormalUser = true;
      home = "/home/yousuf";
      extraGroups = [
        "networkmanager"
        "wheel"
        "keyd"
        "input"
        "ydotool"
      ];
      hashedPasswordFile = config.sops.secrets.YOUSUFS_PASSWORD.path;
    };
  };

  services = {
    getty.autologinUser = "yousuf";
    keyd.enable = true;
    libinput.enable = true;
    xserver.enable = true;
    gvfs.enable = true; # Enables reading external drives
    udisks2.enable = true; # Enables reading external drives
    automatic-timezoned.enable = true;
    logind.extraConfig = "HandlePowerKey=ignore"; # don’t shutdown when power button is short-pressed
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };
    displayManager = {
      autoLogin.user = "yousuf";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "hyprland-uwsm";
    };
  };

  hardware = {
    asahi = {
      enable = true;
      peripheralFirmwareDirectory = ./firmware;
      experimentalGPUInstallMode = "replace";
      withRust = true;
      setupAsahiSound = true;
    };
  };

  systemd.packages = [ pkgs.libinput-gestures ];

  system.stateVersion = "25.05"; # Don't change this
}
