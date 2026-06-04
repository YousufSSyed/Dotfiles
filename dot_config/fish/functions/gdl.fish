function gdl --wraps='gallery-dl --cookies-from-browser zen' --wraps='gallery-dl --cookies-from-browser firefox ' --description 'alias gdl gallery-dl --cookies-from-browser firefox '
    gallery-dl --cookies-from-browser firefox  $argv
end
