function ydl
    command yt-dlp --ffmpeg-location /run/current-system/sw/bin/ffmpeg --cookies-from-browser "firefox:$FIREFOX_PROFILE" $argv
end
