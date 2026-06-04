{
  config,
  pkgs,
  ...
}:

{

  services = {
    syncthing.dataDir = "/home/yousuf/Sync/.Syncthing-Desktop/";
    navidrome = {
      enable = true;
      settings.MusicFolder = "/home/yousuf/Music";
    };
    immich = {
      enable = true;
      accelerationDevices = null;
      host = "0.0.0.0";
      openFirewall = true;
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

  # Nvidia Settings
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      powerManagement.enable = true;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      open = true;
    };
  };
}
