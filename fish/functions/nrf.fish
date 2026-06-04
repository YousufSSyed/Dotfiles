function nrf --wraps='sudo nixos-rebuild --flake /home/yousuf/.config/nix switch' --description 'alias nrf=sudo nixos-rebuild --flake /home/yousuf/.config/nix switch'
  sudo nixos-rebuild --flake /home/yousuf/.config/nix switch $argv
        
end
