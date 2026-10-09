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
    ./Other/home_assistant.nix
    ./Other/yubal.nix
    ./Other/matter_server.nix
    # ./Other/browsertrix.nix
    # ./Other/sparkyfitness.nix
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

  systemd = {
    timers.update-containers = {
      timerConfig = {
        Unit = "update-containers.service";
        OnCalendar = "daily";
      };
      wantedBy = [ "timers.target" ];
    };
    services.update-containers = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe (
          pkgs.writeShellScriptBin "update-containers" ''
            images=$(${pkgs.podman}/bin/podman ps -a --format="{{.Image}}" | sort -u)

            for image in $images; do
              ${pkgs.podman}/bin/podman pull "$image"
            done
          ''
        );
      };
    };
    user.services = {
      "copyparty" = {
        serviceConfig = {
          ExecStart = "${pkgs.copyparty-most}/bin/copyparty -v /home/yousuf::A --see-dots --daw --dav-mac";
          Type = "oneshot";
          User = "yousuf";
        };
        wantedBy = [ "default.target" ];
      };
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
      comfyui = {
        serviceConfig = {
          ExecStart = "${pkgs.fish}/bin/fish /home/yousuf/.local/share/chezmoi/dot_config/fish/functions/comfyui.fish";
          Type = "oneshot";
          User = "yousuf";
        };
        path = [
          pkgs.fish
          pkgs.uv
        ];
        wantedBy = [ "default.target" ];
      };
    };
  };

  sops.secrets.NEXTAUTH_SECRET.owner = config.services.linkwarden.user;
  networking.hostName = "NixOS-Desktop";

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = true;
  };

  nixpkgs.config.cudaSupport = true;
  services.hardware.bolt.enable = true;
}
