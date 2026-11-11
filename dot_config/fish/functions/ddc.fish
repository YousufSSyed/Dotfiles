function ddc
    switch (hostname)
        case NixOS-Desktop NixOS-Laptop
            set -l values 0x11 0x12 0x0f
            set -l idx (test -n "$argv[1]"; and echo $argv[1]; or echo 2)
            ddcutil setvcp 60 $values[$idx]
        case Mac-Mini
            set -l values 17 18 15
            set -l idx (test -n "$argv[1]"; and echo $argv[1]; or echo 1)
            /Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay set -ddc=$values[$idx] -vcp=inputSelect
    end
end
