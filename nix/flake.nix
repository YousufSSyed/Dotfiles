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
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";
    youtube-tui.url = "github:Siriusmart/youtube-tui";
    timewall.url = "github:bcyran/timewall";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.NixOS-Desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # inputs.home-manager.nixosModules.home-manager
          inputs.espanso-fix.nixosModules.espanso-capdacoverride
          inputs.sops-nix.nixosModules.sops
          # inputs.stylix.nixosModules.stylix
          ./configuration.nix
          ./hardware-configuration.nix
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            environment.systemPackages = [ inputs.affinity-nix.packages.x86_64-linux.v3 ];
          }
        ];
      };
    };
}
