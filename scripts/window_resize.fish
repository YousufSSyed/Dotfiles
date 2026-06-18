#!/usr/bin/env fish
alias math "math -s 0 -m ceiling"
set gaps (hyprctl getoption general:gaps_out -j | jq -r ".custom" | string split " ") # top right bottom left window gaps
set resolution (hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.width) \(.height) \(.scale)"' | string split " ")
set resolution[1] (math {$resolution[1]} \/ {$resolution[3]})
set resolution[2] (math {$resolution[2]} \/ {$resolution[3]})

set height (math {$resolution[2]} - {$gaps[1]} - {$gaps[3]})
set width (math {$resolution[1]} - {$gaps[2]} - {$gaps[4]})
set position "$(math {$gaps[4]}) $(math {$gaps[1]})"

echo $height $width $position

switch $argv[1]
    case 1 # Left half of the screen 
        set width (math {$resolution[1]} \/ 2 - {$gaps[4]})
    case 2 # Right half of the screen
        set width (math {$resolution[1]} \/ 2 - {$gaps[2]})
        set position "$(math {$resolution[1]} \/ 2) $(math {$gaps[1]})"
    case 3 # 2/3 width, right side
        set width (math {$resolution[1]} \* 2 \/ 3 - {$gaps[2]})
        set position "$(math {$resolution[1]} \/ 3) $(math {$gaps[1]})"
    case 4 # 2/3 width, left side
        set width (math {$resolution[1]} \* 2 \/ 3 - {$gaps[4]})
end

hyprctl dispatch resizeactive exact $width $height
hyprctl dispatch moveactive exact $position
