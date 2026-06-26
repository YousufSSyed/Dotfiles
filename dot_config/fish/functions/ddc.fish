function ddc --description "Switch display input: 1=DP-1, 2=DP-2, 3=HDMI"
    switch (hostname)
        case NixOS-Desktop NixOS-Laptop
            set -l values 0x0f 0x10 0x12
            set -l idx (test -n "$argv[1]"; and echo $argv[1]; or echo 1)
            ddcutil setvcp 60 $values[$idx]
        case Mac-Mini
            set -l values 15 16 18
            set -l idx (test -n "$argv[1]"; and echo $argv[1]; or echo 2)
            /Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay set -ddc=$values[$idx] -vcp=inputSelect
    end
end
