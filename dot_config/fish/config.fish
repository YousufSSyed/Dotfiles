set -Ux RIPGREP_CONFIG_PATH ~/.config/.ripgreprc
set -gx FZF_DEFAULT_COMMAND "fd -H ."

if status is-interactive
	abbr --add "funcsave" funcsave -d ~/.local/share/chezmoi/dot_config/fish/functions
	cd ~/Downloads/
	set -U fish_greeting
	fish_vi_key_bindings
	zoxide init fish | source
	starship init fish | source
	atuin init fish --disable-up-arrow | source
end
