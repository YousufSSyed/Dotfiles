function nrf
    switch (hostname)
        case NixOS-Desktop NixOS-Laptop
            sudo nixos-rebuild switch --option cores 8 --flake $HOME/.local/share/chezmoi#NixOS-Desktop $argv
        case Mac-Mini
            sudo darwin-rebuild switch --flake $HOME/.local/share/chezmoi#Mac-Mini $argv
    end
end