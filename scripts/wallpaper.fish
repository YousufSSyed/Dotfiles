set wallpapers \
"/home/yousuf/Assets/Wallpapers/0.png" \
"/home/yousuf/Assets/Wallpapers/1.png" \
"/home/yousuf/Assets/Wallpapers/2.png" \
"/home/yousuf/Assets/Wallpapers/3.png" \
"/home/yousuf/Assets/Wallpapers/4.png" \
"/home/yousuf/Assets/Wallpapers/5.png" \
"/home/yousuf/Assets/Wallpapers/6.png" \
"/home/yousuf/Assets/Wallpapers/7.png" \

set time (date '+%H %M' | string split " ")
set hour (math $time[1] % 8 + 1) 
set hour2 (math \($time[1] + 1\) % 8 + 1)
set mins (math $time[2] / 60)

/run/current-system/sw/bin/ffmpeg -nostdin -i $wallpapers[$hour] -i $wallpapers[$hour2] \
		-filter_complex "[1]colorchannelmixer=aa=$mins [img]; [0][img]overlay" -c:v png -compression_level 0 /dev/shm/image.png -y
/run/current-system/sw/bin/awww img --transition-type none /dev/shm/image.png
