function windowsboot --wraps='systemdctl reboot --boot-loader-entry=auto-windows' --description 'alias windowsboot systemdctl reboot --boot-loader-entry=auto-windows'
    systemctl reboot --boot-loader-entry=auto-windows $argv
end
