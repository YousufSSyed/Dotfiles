{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./nixos.nix
    ./Other/nixos_laptop_hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
  ];

  hardware.enableAllFirmware = false;

  # services.avahi.enable = true;
  # services.geoclue2.enable = true;
  # services.geoclue2.submitData = true;
  # services.geoclue2.enableWifi = false;
  # services.geoclue2.enableDemoAgent = lib.mkForce true;

  systemd.user.services = {
    "obsidian" = {
      script = "${pkgs.watchexec}/bin/watchexec -w /home/yousuf/Sync/Obsidian /home/yousuf/.local/share/chezmoi/scripts/obsidian.fish";
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
    "desktop-mounting" = {
      serviceConfig = {
        ExecStartPre = "${pkgs.uutils-coreutils-noprefix}/bin/mkdir -p /home/yousuf/NixOS-Desktop/";
        ExecStart = "${pkgs.rclone}/bin/rclone mount --config /home/yousuf/.config/rclone/rclone.conf --vfs-cache-mode writes --dir-cache-time 5s NixosDesktop-dav: /home/yousuf/NixOS-Desktop/";
        ExecStop = "${pkgs.fuse}/bin/fusermount -uz /home/yousuf/NixOS-Desktop/";
        Type = "oneshot";
        User = "yousuf";
        Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
      };
      wantedBy = [ "default.target" ];
    };
    "copyparty" = {
      serviceConfig = {
        ExecStart = "${pkgs.copyparty-most}/bin/copyparty -v /home/yousuf::A --see-dots";
        Type = "oneshot";
        User = "yousuf";
      };
      wantedBy = [ "default.target" ];
    };
  };

  services.hardware.bolt.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.pd.enable = true;

  networking.hostName = "NixOS-Laptop";

  system = {
    autoUpgrade = {
      # in-progress PR for autoupgrade on darwin: https://github.com/nix-darwin/nix-darwin/pull/1682
      enable = true;
      flags = [ "--print-build-logs" ];
      flake = "path:///home/yousuf/.local/share/chezmoi";
    };
  };

  systemd.services = {
    nixos-upgrade = {
      after = [ "flake-update.service" ];
      requires = [ "flake-update.service" ];
    };
    flake-update = {
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

}
