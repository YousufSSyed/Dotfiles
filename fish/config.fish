set -Ux STARSHIP_CONFIG ~/.local/share/chezmoi/misc/starship.toml
set -Ux RIPGREP_CONFIG_PATH ~/.local/share/chezmoi/misc/.ripgreprc
set -gx FZF_DEFAULT_COMMAND "fd -H ."

if status is-interactive
	set -p fish_function_path ~/.local/share/chezmoi/fish/functions
	abbr --add "funcsave" funcsave -d ~/.local/share/chezmoi/fish/functions
	cd ~/Downloads/
	set -U fish_greeting
	fish_vi_key_bindings
	zoxide init fish | source
	starship init fish | source
	atuin init fish --disable-up-arrow | source
end