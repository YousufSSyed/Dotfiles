{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  environment.systemPackages = with pkgs; [
    # Apps
    kitty
    neovide
    neovim
    qbittorrent
    megabasterd
    ruffle
    vscode
    diff-so-fancy
    delta
    dolphin-emu
    copyparty-most

    lazygit

    # Command Line Tools / CLIs
    uutils-coreutils-noprefix
    coreutils-prefixed
    whisper-cpp
    tree-sitter
    gnumake
    fd
    fzf
    eza
    gcc
    cmake
    bat
    zoxide
    ripgrep
    starship
    bottom
    yazi
    sd
    ffmpeg-full
    pkg-config
    lnav
    jujutsu
    yt-dlp
    gallery-dl
    exiftool
    unrar
    imagemagick
    tesseract
    socat
    age
    sops
    yq-go
    jnv
    jq
    p7zip
    whois
    git-filter-repo
    tig
    atuin
    pastel
    wget
    chezmoi
    rclone
    watchexec
    dua
    gifski
    wordnet
    nix-init
    immich-go
    spotdl
    libjxl
    nh
    fish

    # Language Packages
    # Misc languages
    pkgs.rust-bin.stable.latest.default
    rust-analyzer
    markdown-oxide
    nixfmt
    nixd
    hyprls
    uv
    # Golang
    go
    gopls
    # Lua
    stylua
    lua-language-server
    # JS
    biome
    yarn
    nodejs

    # Misc Packages
    nerd-fonts.iosevka
    dconf
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
