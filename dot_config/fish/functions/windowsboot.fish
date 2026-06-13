function windowsboot --wraps='systemdctl reboot --boot-loader-entry=auto-windows' --description 'alias windowsboot systemdctl reboot --boot-loader-entry=auto-windows'
    systemdctl reboot --boot-loader-entry=auto-windows $argv
end
