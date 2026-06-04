	#!/usr/bin/env bash

	die(){
    notify-send "$1"
    exit 1
  }
  cleanup(){
    [[ -n $1 ]] && rm -r "$1"
  }
  SCR_IMG=$(mktemp -d) || die "failed to take screenshot"
  trap "cleanup '$SCR_IMG'" EXIT
	if [ -z "$region" ]; then
		exit
	fi

	for i in "${!region[@]}" 
	do
		region[i]=$(expr ${region[i]} "*" "2")
	done
	grim -c -g $(slurp -b 00000000 -c 80808080 -w 2) 

	magick "$SCR_IMG/scr.tiff" -crop "${region[0]}x${region[1]}+${region[2]}+${region[3]}" "$SCR_IMG/scr.tiff" 

	tesseract "$SCR_IMG/scr.tiff" "$SCR_IMG/scr" &> /dev/null || die "failed to extract text"
  wl-copy < "$SCR_IMG/scr.txt" || die "failed to copy text to clipboard"
  # notify-send "Text extracted from image" "$(head -c 100 "$SCR_IMG/scr.txt")" || die "failed to send notification"
  exit
