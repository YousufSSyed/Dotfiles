function lor --wraps=/home/yousuf/Assets/Scripts/loopvideo.fish --description 'alias lor=/home/yousuf/Assets/Scripts/loopvideo.fish'
		if not test -d "/run/media/yousuf/Tertiary/"; udisksctl mount -b /dev/nvme2n1p4; end
    /home/yousuf/Assets/Scripts/loopvideo.fish $argv
end
