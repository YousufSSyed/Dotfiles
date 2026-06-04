#!/usr/bin/env fish

set DirName (date -d (string sub --length 10 (basename $argv)) '+%Y-%m %B %Y')
if test -z "$DirName"; exit; end
set NoteDir "/home/yousuf/Sync/Obsidian/Daily Notes/$DirName"
if not test -d $NoteDir; mkdir $NoteDir; end
if test (date "+%H") -lt $HOUR; set yesterday "yesterday"; end
set DateCompleted (date -d "$yesterday" "+%Y-%m-%d")
yq -i --front-matter=process ".[\"Date Completed\"] = \"$DateCompleted\" | .[\"Date Completed\"] tag=\"!!str\" style=\"\"" $argv
mv $argv $NoteDir/(basename $argv)
echo $NoteDir/(basename $argv)
