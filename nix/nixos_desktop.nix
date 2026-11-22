{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./nixos.nix
    ./base.nix
    ./Other/nixos_desktop_hardware.nix
    ./Other/home_assistant.nix
    ./Other/yubal.nix
    ./Other/matter_server.nix
    # ./Other/browsertrix.nix
    # ./Other/sparkyfitness.nix
  ];

  _module.args = {
    firefoxProfile = "desktop-profile";
    hostName = "NixOS-Desktop";
    thunderboltAddress = "10.0.0.3/24";
  };

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
    services = {
      update-containers = {
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
      navidrome.serviceConfig.ProtectHome = lib.mkForce "tmpfs";
    };
    user.services = {
      laptop-mounting = {
        serviceConfig = {
          ExecStartPre = "${pkgs.uutils-coreutils-noprefix}/bin/mkdir -p /home/yousuf/NixOS-Laptop/";
          ExecStart = "${pkgs.rclone}/bin/rclone mount --config /home/yousuf/.config/rclone/rclone.conf --vfs-cache-mode writes --dir-cache-time 5s NixosLaptop-dav: /home/yousuf/NixOS-Laptop/";
          ExecStop = "${pkgs.fuse}/bin/fusermount -uz /home/yousuf/NixOS-Laptop/";
          Type = "notify";
          User = "yousuf";
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        };
        wantedBy = [ "default.target" ];
      };
      comfyui = {
        script = "${pkgs.fish}/bin/fish /home/yousuf/.local/share/chezmoi/dot_config/fish/functions/comfyui.fish";
        serviceConfig = {
          User = "yousuf";
          Restart = "on-failure";
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

  services.samba = {
    package = pkgs.samba4Full;
    usershares.enable = true;
    enable = true;
    openFirewall = true;
    settings = {
      homes = {
        comment = "Homes Directories";
        "valid users" = "%S";
        "read only" = "no";
        "create mask" = "0700";
        "directory mask" = "0700";
      };
      global = {
        "server signing" = "disabled";
        "write cache size" = 2097152;
        "min receivefile size" = 16384;
        "getwd cache" = true;
        "vfs objects" = "fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "fruit:posix_rename" = "yes";
      };
    };
  };

  services.nfs = {
    server = {
      enable = true;
      # fixed rpc.statd port; for firewall
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
      extraNfsdConfig = "";
      nproc = 64;
      exports = ''
        /home/yousuf *(rw,async,nohide,no_subtree_check,insecure,crossmnt,all_squash,anonuid=1000,anongid=100)
      '';
      createMountPoints = true;
    };
    settings = {
      nfsd.udp = false;
      nfsd.vers3 = false;
      nfsd.vers4 = true;
      nfsd."vers4.0" = true;
      nfsd."vers4.1" = false;
      nfsd."vers4.2" = false;
    };
  };
  networking.firewall = {
    enable = true;
    # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };

}
