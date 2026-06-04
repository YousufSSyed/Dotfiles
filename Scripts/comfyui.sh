#!/usr/bin/env fish
set dir "/home/yousuf/Mac/Secondary/[0] Stable Diffusion/"
if not test -d $dir
	echo "Comfyui drive doesn't seem to be mounted."
	exit 1
end
mkdir -p "$dir/2026-12-31 Current/Outputs"
cd ~/Assets/ComfyUI/ && uv run python main.py --listen --output-directory "$dir/2026-12-31 Current/Outputs" $argv
