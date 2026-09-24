{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    # Apps
    kitty
    neovide
    neovim
    qbittorrent
    megabasterd
    dolphin-emu
    ruffle
    copyparty-most
    losslesscut-bin
    tableplus
    vesktop
    mullvad-browser

    # Command Line Tools / CLIs
    git
    uutils-coreutils-noprefix
    coreutils-prefixed
    fd
    fzf
    eza
    bat
    whisper-cpp
    zoxide
    ripgrep
    starship
    bottom
    yazi
    sd
    (ffmpeg-full.override {
      withUnfree = true;
      withCudaLLVM = false;
      withCudaNVCC = false;
    })
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
    (pkgs.mpv.override {
      scripts = [
        # pkgs.mpvScripts.modernz
        pkgs.mpvScripts.thumbfast
      ];
      mpv-unwrapped = pkgs.mpv-unwrapped.override {
        ffmpeg = (
          ffmpeg-full.override {
            withUnfree = true;
            withCudaLLVM = false;
            withCudaNVCC = false;
          }
        );
      };
    })

    lazygit
    diff-so-fancy
    delta

    # Nix tools
    nix-init
    nh

    # Language Packages
    # Misc languages
    rust-analyzer
    markdown-oxide
    nixfmt
    nixd
    uv
    libclang
    # Golang
    go
    gopls
    # Lua
    stylua
    lua-language-server
    # JS
    # biome
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
    claude-agent-acp

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
