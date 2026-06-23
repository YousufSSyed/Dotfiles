function nrf
	switch (hostname)
		case NixOS-Desktop
			sudo nh os switch -R $HOME/.local/share/chezmoi#NixOS-Desktop
		case NixOS-Desktop NixOS-Laptop
			sudo nh os switch -R $HOME/.local/share/chezmoi#NixOS-Laptop
		case Mac-Mini
			sudo nh darwin switch -R $HOME/.local/share/chezmoi#Mac-Mini
	end
end
