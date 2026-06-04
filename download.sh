#!/opt/homebrew/bin/fish
wget --content-disposition -P /Users/yousuf/Downloads "$1" 2>&1 | grep "Saving to" | sd 'Saving to: ‘(.+?)’' '$1' | read fileName
touch $fileName
open $fileName -a Preview