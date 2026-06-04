{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      # url = "github:0xc000022070/zen-browser-flake?rev=5c9624f3d0176727284678aebf677770dd1375b2";
      url = "github:0xc000022070/zen-browser-flake?rev=0618a22e6fb6f13181807f0e14087192d459b2a0";
      # url = "github:0xc000022070/zen-browser-flake";
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
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    hyprfloat.url = "github:yz778/hyprfloat";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    kwin-effects-forceblur = {
      # url = "github:LightWayUp/kwin-effects-forceblur";
      url = "github:Kayzels/kwin-effects-forceblur/wallpaper-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-glass = {
      url = "github:4v3ngR/kwin-effects-glass";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            environment.systemPackages = [ inputs.affinity-nix.packages.x86_64-linux.v3 ];
          }
        ];
      };
    };
}
