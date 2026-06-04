function gcl --wraps='git clone --depth 1' --description 'alias gcl git clone --depth 1'
    git clone --depth 1 $argv
end
