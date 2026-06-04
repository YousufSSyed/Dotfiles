{
  inputs = {
    hyprshell = {
      url = "github:H3rmt/hyprswitch?ref=hyprshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib/?ref=slurp_args";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aw-hyprland = {
      url = "github:bobvanderlinden/aw-watcher-window-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      # inputs.hyprland.follows = "hyprland";
      # inputs.hyprland.follows = "nixpkgs";
    };
    # nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    timewall.url = "github:bcyran/timewall";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.NixOS-Desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            # environment.systemPackages = [ inputs.affinity-nix.packages.x86_64-linux.v3 ];
          }
        ];
      };
    };
}
