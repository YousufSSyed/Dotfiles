{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./nixos.nix
    ./Other/nixos_desktop_hardware.nix
  ];

  services = {
    navidrome = {
      enable = true;
      settings.Address = "0.0.0.0";
      settings.MusicFolder = "/home/yousuf/Music";
    };
    immich = {
      enable = true;
      host = "0.0.0.0";
      accelerationDevices = null;
    };
    linkwarden = {
      enable = true;
      secretFiles.NEXTAUTH_SECRET = config.sops.secrets."NEXTAUTH_SECRET".path;
      enableRegistration = true;
      environment = {
        NEXTAUTH_URL = "http://localhost:3000/api/v1/auth";
      };
    };
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  programs = {
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
  };

  system.autoUpgrade.dates = "0:00";
  nixpkgs.config.cudaSupport = true;

  systemd = {
    # Systemd Timers
    user.timers."obsidian" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "obsidian.service";
        OnCalendar = "5m";
        OnBootSec = "1s";
      };
    };
    user.services."wallpaper" = {
      script = "${pkgs.fish}/bin/fish /home/yousuf/Sync/Scripts/wallpaper.fish";
      serviceConfig = {
        Type = "oneshot";
        User = "yousuf";
      };
    };
    services = {
      navidrome.serviceConfig.ProtectHome = lib.mkForce "tmpfs";
      flake-update = {
        description = "Update flake inputs";
        unitConfig = {
          StartLimitIntervalSec = 300;
          StartLimitBurst = 5;
        };
        serviceConfig = {
          ExecStartPre = "${pkgs.networkmanager}/bin/nm-online";
          ExecStart = "${pkgs.nix}/bin/nix flake update --flake /home/yousuf/.local/share/chezmoi";
          Restart = "on-failure";
          RestartSec = "30";
          Type = "oneshot";
          User = "yousuf";
        };
        path = [
          pkgs.nix
          pkgs.git
          pkgs.host
          pkgs.networkmanager
        ];
      };
    };
  };

  # Nvidia Settings
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      # powerManagement.enable = true;
      # nvidiaPersistenced = true;
      # nvidiaSettings = true;
      open = true;
    };
  };
}
