function nrf --wraps='sudo nixos-rebuild switch'
    set args switch --option cores 8
    switch (uname)
        case Linux
            sudo nixos-rebuild --upgrade $args --flake $HOME/.local/share/chezmoi#NixOS-Desktop $argv
        case Darwin
            sudo darwin-rebuild $args --flake $HOME/.local/share/chezmoi#Mac-Mini $argv
    end
end