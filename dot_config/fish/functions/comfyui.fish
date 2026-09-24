function comfyui
    set dir "/home/yousuf/Mac/Secondary/[0] Stable Diffusion/"
    if not test -d $dir
        echo "Directory for outputs not found."
        exit 1
    end
    mkdir -p "$dir/$(date +%Y-%m-%d)/Outputs"
    cd ~/Assets/ComfyUI/ && uv run python main.py --listen --output-directory "$dir/2026-12-31 Current/Outputs" $argv
end
