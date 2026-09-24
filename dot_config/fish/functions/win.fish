function win --wraps='systemdctl reboot --boot-loader-entry=auto-windows' --description 'alias win systemdctl reboot --boot-loader-entry=auto-windows'
    systemctl reboot --boot-loader-entry=auto-windows $argv
    and
