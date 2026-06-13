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
    user.services."obsidian" = {
      script = "${pkgs.watchexec}/bin/watchexec -w /home/yousuf/Sync/Obsidian ${pkgs.fish}/bin/fish /home/yousuf/.local/share/chezmoi/scripts/obsidian.fish";
      environment = config.environment.variables;
      serviceConfig = {
        Type = "simple";
        User = "yousuf";
      };
      path = [
        pkgs.git
        pkgs.fish
        pkgs.watchexec
        pkgs.libnotify
        pkgs.openssh
      ];
      wantedBy = [ "default.target" ];
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
