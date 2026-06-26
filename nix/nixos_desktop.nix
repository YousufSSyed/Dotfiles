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

  systemd = {
    services = {
      navidrome.serviceConfig.ProtectHome = lib.mkForce "tmpfs";
      nixos-upgrade = {
        after = [ "flake-update.service" ];
        requires = [ "flake-update.service" ];
      };
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
    user.services = {
      "copyparty".serviceConfig.ExecStart =
        "${pkgs.copyparty-most}/bin/copyparty -v /home/yousuf::A --see-dots";
      "laptop-mounting" = {
        serviceConfig = {
          ExecStartPre = "${pkgs.uutils-coreutils-noprefix}/bin/mkdir -p /home/yousuf/NixOS-Laptop/";
          ExecStart = "${pkgs.rclone}/bin/rclone mount --config /home/yousuf/.config/rclone/rclone.conf --vfs-cache-mode writes --dir-cache-time 5s NixosLaptop-dav: /home/yousuf/NixOS-Laptop/";
          ExecStop = "${pkgs.fuse}/bin/fusermount -uz /home/yousuf/NixOS-Laptop/";
          Type = "oneshot";
          User = "yousuf";
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        };
        wantedBy = [ "default.target" ];
      };
    };
  };

  sops = {
    secrets.NEXTAUTH_SECRET.owner = config.services.linkwarden.user;
  };

  networking = {
    hostName = "NixOS-Desktop";
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"

      "smlight"

      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
  };
}
