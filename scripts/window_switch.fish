#!/usr/bin/env fish
argparse 'c/class=' 'a/appcommand=' -- $argv

set values (hyprctl clients -j | jq --arg class "$_flag_c" -r '[
    ([.[] | select(.class == $class)] | sort_by(.focusHistoryID) | .[0].focusHistoryID),
    (.[] | select(.focusHistoryID == 1) | .address),
    ([.[] | select(.class == $class)] | sort_by(.focusHistoryID) | .[0].address)
  ] | join(" ")' | string split " ")

if test $values[1] = "0"
	set top_window $values[2]
else if not test -n $values[1]
	eval $_flag_a
	set top_window $_flag_c
else
	set top_window $values[3]
end

hyprctl dispatch alterzorder top,address:$top_window
hyprctl dispatch focuswindow address:$top_window
