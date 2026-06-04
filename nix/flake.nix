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
      url = "github:youwen5/zen-browser-flake";
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon/";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    swww.url = "github:LGFae/swww";
    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";
    youtube-tui.url = "github:Siriusmart/youtube-tui";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.NixOS-MBP = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.apple-silicon.nixosModules.default
          # inputs.home-manager.nixosModules.home-manager
          inputs.espanso-fix.nixosModules.espanso-capdacoverride
          inputs.sops-nix.nixosModules.sops
          # inputs.stylix.nixosModules.stylix
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
