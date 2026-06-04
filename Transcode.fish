#!/opt/homebrew/bin/fish

for vid in *.mkv
    if ffmpeg -i $vid -c copy -c:v libx265 (path change-extension '' $vid).mp4 -y
        rm $vid
    end
end