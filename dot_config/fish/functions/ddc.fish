function ddc
    switch (hostname)
        case NixOS-Desktop NixOS-Laptop
            ddcutil setvcp 60 16
        case Mac-Mini
            /Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay set -ddc=18 -vcp=inputSelect
    end
end
