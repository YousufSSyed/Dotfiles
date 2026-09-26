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

  networking.hostName = "NixOS-Laptop";
  system.autoUpgrade.dates = "1:00";

  # environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
  #   [Serial Keyboards]
  #   MatchUdevType=keyboard
  #   MatchName=keyd virtual keyboard
  #   AttrKeyboardIntegration=internal
  # '';

  services.logind.settings.Login = {
    enable = true;
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    # If you use a dock or external monitor regularly:
    HandleLidSwitchDocked = "ignore";
    LidSwitchIgnoreInhibited = "no";
  };

  services.acpid = {
    enable = true;
    handlers.lid = {
      event = "button/lid.";
      action = ''
        if grep -q closed /proc/acpi/button/lid/*/state; then
        XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.eDP-1.disable
        else
         XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.eDP-1.enable
        fi
      '';
    };
  };
}
