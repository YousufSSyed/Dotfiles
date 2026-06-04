set -U fish_greeting
set -Ux STARSHIP_CONFIG ~/.config/fish/starship.toml
set -Ux RIPGREP_CONFIG_PATH ~/.config/fish/.ripgreprc
set -gx FZF_DEFAULT_COMMAND "fd -H ."
fish_vi_key_bindings
zoxide init fish | source
starship init fish | source

if status is-interactive
	cd ~/Downloads/
end
