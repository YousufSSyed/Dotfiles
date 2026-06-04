#!/usr/bin/env fish

argparse 'a/ab-loop-a=' 'b/ab-loop-b=' 'h/help' -- $argv
if set -q _flag_help
		echo "Usage: mpv_loop [OPTIONS] FILENAME"
		echo ""
		echo "Options:"
		echo "  -a, --ab-loop-a VALUE    Start time for AB loop (default: 0)"
		echo "  -b, --ab-loop-b VALUE    End time for AB loop"
		echo "  -h, --help               Show this help"
		echo ""
		echo "Example:"
		echo "  mpv_loop -a 0 -b 5.528 'video.webm'"
		return 0
end

set -l music_dir "/run/media/yousuf/Untitled/Music"
if set -q _flag_ab_loop_a
		set loop_a $_flag_ab_loop_a
end
if set -q _flag_ab_loop_b
		set loop_b $_flag_ab_loop_b
end
set filename $argv[1]

if test -f "$filename"
		set filepath "$filename"
else if test -f "$music_dir/$filename"
		set filepath "$music_dir/$filename"
else
		set filepath (find "$music_dir" -type f -iname "*$filename*" 2>/dev/null | fzf --select-1 --exit-0 --query="$filename")
		if test -z "$filepath"
				echo "Error: No matching file found in $music_dir" >&2
				return 1
		end
		echo "Found: $filepath" >&2
end

set mpv_cmd "mpv --script-opts=loop=yes"
if test -n "$loop_a"
	set -a mpv_cmd --ab-loop-a=$loop_a
end
if test -n "$loop_b"
	set -a mpv_cmd --ab-loop-b=$loop_b
end
set -a mpv_cmd \"$filepath\"

echo $mpv_cmd
eval $mpv_cmd
