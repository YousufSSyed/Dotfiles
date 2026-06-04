{
  description = "A simple NixOS flake";

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
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon/";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    swww.url = "github:LGFae/swww";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      system = "aarch64-linux";
      nixosConfigurations.NixOS-MBP = nixpkgs.lib.nixosSystem {
        specialArgs.flake-inputs = inputs;
        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          {
            nixpkgs.overlays = [
              inputs.dolphin-overlay.overlays.default
            ];
          }
          inputs.apple-silicon.nixosModules.default
          inputs.nixos-cosmic.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.espanso-fix.nixosModules.espanso-capdacoverride
          inputs.sops-nix.nixosModules.sops
          ./configuration.nix
        ];
      };
    };
}
