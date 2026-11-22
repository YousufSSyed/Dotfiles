{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./base.nix
    ./nixos.nix
    ./Other/nixos_laptop_hardware.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
  ];

  _module.args = {
    firefoxProfile = "laptop-profile";
    hostName = "NixOS-Laptop";
    thunderboltAddress = "10.0.0.1/24";
  };

  environment.systemPackages = with pkgs; [
    # Language Packages
    # Misc languages
    pkgs.rust-bin.stable.latest.default
    rust-analyzer
    libclang
    # Golang
    go
    gopls
    # JS
    biome
    yarn
    nodejs
    vtsls

    # Other Dev Packages
    pkg-config
    gnumake
    gcc
    cmake

    # LLM-related packages
    # opencode
    claude-code
    claude-agent-acp
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
  };

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.pd.enable = true;

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

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
