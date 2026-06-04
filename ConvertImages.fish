#!/opt/homebrew/bin/fish

echo Now processing folder $folder
for file in (find . -name \*.png -o -name \*.jpg -o -name \*.webp)
    magick $file (path change-extension '' $file).jxl
    if test -f (path change-extension '' $file).jxl
        exiftool -overwrite_original -m -tagsFromFile $file "-UserComment<Parameters" "-filecreatedate<filecreatedate" "-filemodifydate<filemodifydate" (path change-extension '' $file).jxl
        rm $file
    end
end