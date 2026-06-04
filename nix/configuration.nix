{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  environment.sessionVariables.MOZ_GMP_PATH = [
    "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed"
  ];

  # Packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    inputs.dolphin-overlay.overlays.default
    inputs.nixos-aarch64-widevine.overlays.default
  ];
  environment.systemPackages = with pkgs; [
    # Apps
    # pkgs.kitty
    # pkgs.neovide
    pkgs.obsidian
    pkgs.activitywatch
    pkgs.waybar
    pkgs.nwg-dock-hyprland
    pkgs.qview
    # pkgs.ulauncher
    pkgs.font-manager
    pkgs.dissent
    pkgs.qbittorrent
    pkgs.swaylock
    pkgs.megabasterd
    pkgs.gimp3-with-plugins
    pkgs.github-desktop
    pkgs.rofi-wayland
    pkgs.ruffle

    # Command Line Tools / CLIs
    pkgs.coreutils-prefixed
    pkgs.uutils-coreutils-noprefix
    pkgs.gnumake
    pkgs.fd
    pkgs.fzf
    pkgs.eza
    pkgs.gcc
    pkgs.cmake
    # pkgs.bat
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
    pkgs.sunwait
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal
    pkgs.hyprpanel
    pkgs.base16-schemes
    pkgs.widevine-cdm

    # Flakes
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.hyprshell.packages.${pkgs.system}.hyprshell
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprland-contrib.packages.${pkgs.system}.hdrop
    inputs.hyprland-contrib.packages.${pkgs.system}.shellevents
    inputs.swww.packages.${pkgs.system}.swww
    # inputs.youtube-tui.packages.${pkgs.system}.youtube-tui
    pkgs.youtube-tui
    pkgs.rust-bin.stable.latest.default
    inputs.timewall.packages.${pkgs.system}.timewall

    # KDE Packages
    kdePackages.dolphin
    kdePackages.qtsvg
    pkgs.haruna
    pkgs.libsForQt5.kservice
  ];

  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "0:00";
    randomizedDelaySec = "45min";
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # App modules
  programs = {
    ydotool.enable = true;
    # neovim.enable = true;
    # fish.enable = true;
    # yazi.enable = true;
    git.enable = true;
    firefox.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # Hpyrland
    hyprland.withUWSM = true;
    hyprland.enable = true;
    hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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

  services.hypridle.enable = true;

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

  hardware = {
    asahi = {
      # extractPeripheralFirmware = false;
      peripheralFirmwareDirectory = ./firmware;
      setupAsahiSound = true;
      enable = true;
      experimentalGPUInstallMode = "replace";
    };
  };

  systemd.packages = [ pkgs.libinput-gestures ];

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    autoEnable = true;
    enable = false;
  };

  programs = {
    neovim.enable = true;
    fish.enable = true;
    yazi.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # See next snippet
    users.yousuf = import ./home.nix;
  };

  sops = {
    age.keyFile = "/home/yousuf/Assets/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets.OBSIDIAN_REST_API_KEY.owner = config.users.users.yousuf.name;
    secrets.YOUSUFS_PASSWORD.neededForUsers = true;
  };

  programs.bash.shellInit = ''
    		export OBSIDIAN_REST_API_KEY="$(cat ${config.sops.secrets.OBSIDIAN_REST_API_KEY.path})"
    		export GRIMBLAST_HIDE_CURSOR=0
    		export SOPS_AGE_KEY_FILE="/home/yousuf/Assets/sops/age/keys.txt"
    		export SLURP_ARGS="-B 00000000 -b 00000000 -c 80808080 -w 2"
    		export MANPAGER="nvim +Man!"
    		export EDITOR="nvim"
  '';

  networking = {
    hostName = "NixOS-MBP"; # Computer Name
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
    atuin.enable = true;
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
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  };

  system.stateVersion = "25.11";
}
