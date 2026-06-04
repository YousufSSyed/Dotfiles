#!/usr/bin/env fish
alias math "math -s 0 -m ceiling"
set gaps (hyprctl getoption general:gaps_out -j | jq -r ".custom" | string split " ")
set resolution (wlr-randr --json | jq -r '.[].modes[] | select(.current == true) | "\(.width) \(.height)"' | string split " ")
set scale 2
set resolution[1] (math {$resolution[1]} / $scale)
set resolution[2] (math {$resolution[2]} / $scale)
set height (math {$resolution[2]} - {$gaps[1]} - {$gaps[3]})

switch $argv[1]
case 1 # Maximize
	set width (math {$resolution[1]} - {$gaps[2]} - {$gaps[4]})
	set position "$(math {$gaps[4]}) $(math {$gaps[1]})"
argparse 'c/class=' 'a/appcommand=' -- $argv
case 2	# Left half of the screen 
	set width (math {$resolution[1]} / 2 - {$gaps[4]})
	set position "$(math {$gaps[4]}) $(math {$gaps[1]})"
case 3	# Right half of the screen
	set width (math {$resolution[1]} / 2 - {$gaps[2]})
	set position "$(math {$resolution[1]} / 2) $(math {$gaps[1]})"
end

echo $height
echo $width
echo $position

hyprctl dispatch resizeactive exact $width $height
hyprctl dispatch moveactive exact  $position
