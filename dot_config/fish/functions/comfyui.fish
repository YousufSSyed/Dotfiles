#!/usr/bin/env fish
cd ~/Assets/ComfyUI/
uv pip install -r requirements.txt
git pull origin master
set dir "/home/yousuf/Secondary/[0] Stable Diffusion/"
if not test -d $dir
    echo "Comfyui drive doesn't seem to be mounted."
    exit 1
end
mkdir -p "$dir/2026-12-31 Current/Outputs"
uv run python main.py --listen --output-directory "$dir/2026-12-31 Current/Outputs" $argv
