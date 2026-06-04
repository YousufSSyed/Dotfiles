#!/usr/bin/env bash
region=($(slurp -b "#00000000" -c "#80808080" -w 2 -f "%w %h %x %y"))
if [ -z "$region" ]; then
  exit
fi

filename="/home/yousuf/Downloads/$(date +%Y-%m-%d\ %I-%M-%S%p) Screenshot.png"
spectacle -nbo "$filename"
for i in "${!region[@]}" 
do
	region[i]=$(expr ${region[i]} "*" "2")
done
magick "$filename" -crop "${region[0]}x${region[1]}+${region[2]}+${region[3]}" "$filename" 
exit
