#!/usr/bin/env fish
set fish_trace on
for file in (find . -name '*.png' -o -name '*.jpg' -o -name '*.webp')
    du -sh "$file"
    set jxl_file (path change-extension '' $file).jxl
    cjxl -d 0 --lossless_jpeg=1 "$file" "$jxl_file"
    if test $status -ne 0
        echo "cjxl -d 0 --lossless_jpeg=1 \"$file\" \"$jxl_file\"" >> error.txt
    else if test -f "$jxl_file"
        exiftool -overwrite_original -m -tagsFromFile "$file" "-UserComment<Parameters" "-filecreatedate<filecreatedate" "-filemodifydate<filemodifydate" "$jxl_file"
        rm "$file"
    end
end
