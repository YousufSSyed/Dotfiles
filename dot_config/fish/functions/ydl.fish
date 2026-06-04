function ydl --wraps=yt-dlp --wraps='wl-paste | yt-dlp  -' --wraps='wl-paste | yt-dlp  -a -' --description 'alias ydl wl-paste | yt-dlp  -a -'
    wl-paste | yt-dlp  -a - $argv
end
