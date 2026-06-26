{
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [
    ./nixos.nix
    ./Other/nixos_laptop_hardware.nix
    inputs.nixos-hardware.nixosModules.asus-zephyrus-gu605my
  ];

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
  };

  networking.hostName = "NixOS-Laptop";
  system.autoUpgrade.dates = "1:00";
}
