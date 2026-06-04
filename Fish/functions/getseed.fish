function getseed
    exiftool -Prompt -b $argv[1] | jq -r '[to_entries[] | select(.value.inputs.noise_seed?) | {key: .key, seed: .value.inputs.noise_seed}] as $seeds | [.. | objects | select(has("noise")) | .noise[0]] as $refs | $seeds | map(select(.key as $k |$refs | index($k)) | .seed) | .[]' | wl-copy
end
