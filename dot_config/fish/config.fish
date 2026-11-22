set -Ux RIPGREP_CONFIG_PATH ~/.config/.ripgreprc
set -gx FZF_DEFAULT_COMMAND "fd -H ."

switch (hostname)
    case NixOS-Laptop
        export FIREFOX_PROFILE="/home/yousuf/.config/mozilla/firefox/laptop-profile"
    case NixOS-Desktop
        export FIREFOX_PROFILE="/home/yousuf/.config/mozilla/firefox/desktop-profile"
    case Mac-Mini
        export FIREFOX_PROFILE="/Users/yousuf/Library/Application Support/org.nixos.firefox/Profiles/mac-profile"
end

if status is-interactive
    abbr --add funcsave funcsave -d ~/.local/share/chezmoi/dot_config/fish/functions
    cd ~/Downloads/
    set -U fish_greeting
    fish_vi_key_bindings
    zoxide init fish | source
    starship init fish | source
    atuin init fish --disable-up-arrow | source
end
