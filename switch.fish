#!/usr/bin/env fish
argparse 'c/class=' 'a/appcommand=' -- $argv
set top_window (hyprctl clients -j | \
		jq -r "[.[] | select(.class == \"$_flag_c\")] | sort_by(.focusHistoryID) | .[0].focusHistoryID")
if test $top_window = "null"
	$_flag_a
	hyprctl dispatch alterzorder top,address:$_flag_c
	hyprctl dispatch focuswindow address:$_flag_c
	return
end
if test $top_window = "0"
	set top_window (hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 1) | .address')
else
	set top_window (hyprctl clients -j | \
			jq -r "[.[] | select(.class == \"$_flag_c\")] | sort_by(.focusHistoryID) | .[0].address")
end

hyprctl dispatch alterzorder top,address:$top_window
hyprctl dispatch focuswindow address:$top_window
