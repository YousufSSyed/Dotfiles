{
  config,
  pkgs,
  lib,
  ...
}:
let
  update-containers = pkgs.writeShellScriptBin "update-containers" ''
    	SUDO=""
    	if [[ $(id -u) -ne 0 ]]; then
    		SUDO="sudo"
    	fi

        images=$($SUDO ${pkgs.podman}/bin/podman ps -a --format="{{.Image}}" | sort -u)

        for image in $images
        do
          $SUDO ${pkgs.podman}/bin/podman pull $image
        done
  '';
in
{
  imports = [
    ./nixos.nix
    ./Other/nixos_desktop_hardware.nix
    ./Other/home_assistant.nix
    ./Other/yubal.nix
    ./Other/matter_server.nix
    ./Other/browsertrix.nix
    ./Other/sparkyfitness.nix
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

  systemd.timers = {
    # ...
    updatecontainers = {
      timerConfig = {
        Unit = "updatecontainers.service";
        OnCalendar = "daily";
      };
      wantedBy = [ "timers.target" ];
    };
    # ...
  };

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
      updatecontainers = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = update-containers;
        };
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

  sops.secrets.NEXTAUTH_SECRET.owner = config.services.linkwarden.user;
  networking.hostName = "NixOS-Desktop";
  system.autoUpgrade.dates = "0:00";

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
}
