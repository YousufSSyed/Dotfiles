{ config, pkgs, ... }:
{
  home = {
    stateVersion = "25.11";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 22;
      x11.enable = true;
      x11.defaultCursor = "macOS";
    };
    packages = [
      pkgs.kitty
      # pkgs.neovim
      pkgs.fish
      pkgs.bat
      pkgs.yazi
      pkgs.neovide
    ];
    file.".local/share/fonts".source = config.lib.file.mkOutOfStoreSymlink "/home/yousuf/Assets/Fonts/";
  };
  # stylix.targets.neovim.enable = true;
  # stylix.targets.neovide.enable = true;
  # stylix.targets.kde.enable = false;
}
