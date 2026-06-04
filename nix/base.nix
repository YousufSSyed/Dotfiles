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
    diff-so-fancy
    delta
    dolphin-emu
    copyparty-most
    losslesscut-bin
    tableplus

    lazygit

    # Command Line Tools / CLIs
    git
    uutils-coreutils-noprefix
    coreutils-prefixed
    whisper-cpp
    fd
    fzf
    eza
    bat
    zoxide
    ripgrep
    starship
    bottom
    yazi
    sd
    ffmpeg-full
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
    jq
    p7zip
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
    immich-go
    spotdl
    libjxl
    fish
    sqlite
    mpvScripts.modernz
    mpvScripts.thumbfast
    (mpv-unwrapped.override {
      ffmpeg = ffmpeg-full;
    })

    # Nix tools
    nix-init
    nh

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

    # Other Dev Packages
    tree-sitter
    pkg-config
    gnumake
    gcc
    cmake

    # Misc Packages
    nerd-fonts.iosevka
    dconf
  ];

  security.sudo.extraConfig = "Defaults pwfeedback";
  nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
