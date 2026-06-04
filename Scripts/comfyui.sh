#!/usr/bin/env fish
if not test -d "/home/yousuf/Mac/[0] Stable Diffusion/"
	echo "Comfyui drive doesn't seem to be mounted."
	exit 1
end
set dir "/home/yousuf/Mac/[0] Stable Diffusion/2026-12-31 Current/Outputs"
mkdir -p "$dir"
cd ~/Assets/ComfyUI/ && uv run python main.py --listen --output-directory "$dir" $argv
