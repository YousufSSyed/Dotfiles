function nrf
	switch (hostname)
		case NixOS-Desktop NixOS-Laptop
			nh os switch $HOME/.local/share/chezmoi#NixOS-Desktop
		case Mac-Mini
			nh darwin switch $HOME/.local/share/chezmoi#Mac-Mini
	end
end
