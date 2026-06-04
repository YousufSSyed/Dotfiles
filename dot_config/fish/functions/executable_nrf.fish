function nrf --wraps='sudo nixos-rebuild --flake /home/yousuf/.config/nix switch'
  sudo nixos-rebuild --upgrade --option cores 8 --flake /home/yousuf/.config/nix switch $argv 
end
