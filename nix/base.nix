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
    dolphin-emu
    copyparty-most
    losslesscut-bin
    tableplus
    feishin

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
    (mpv-unwrapped.override {
      ffmpeg = ffmpeg-full;
    })
    mpvScripts.modernz
    mpvScripts.thumbfast
    lazygit
    diff-so-fancy
    delta

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
    vtsls
    # Other Dev Packages
    tree-sitter
    pkg-config
    gnumake
    gcc
    cmake
    # LLM-related packages
    opencode
    claude-code

    # Misc Packages
    nerd-fonts.iosevka
    dconf
  ];

  security.sudo.extraConfig = "Defaults pwfeedback";
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
