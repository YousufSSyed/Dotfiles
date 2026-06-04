function lyt --wraps='yt-dlp -x -P "/run/media/yousuf/Untitled/Music/"' --wraps="wl-paste | yt-dlp -x -P '/run/media/yousuf/Untitled/Music/' -a -" --description "alias lyt wl-paste | yt-dlp -x -P '/run/media/yousuf/Untitled/Music/' -a -"
		if not test -d "/run/media/yousuf/Tertiary/"; udisksctl mount -b /dev/nvme2n1p4; end
    wl-paste | yt-dlp -x -P '/run/media/yousuf/Untitled/Music/' -a - $argv
end
