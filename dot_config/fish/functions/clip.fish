function clip
    set fileName (osascript -e 'tell application "System Events" to tell process "LosslessCut" to return name of window 1')
    set fileName (echo $fileName | gsed -e 's/LosslessCut - //')
    echo $fileName
    set startTime (pbpaste | gsed -e 's/\t.*//')
    set endTime (pbpaste | gsed -e 's/.*\t//')
    echo $startTime
    echo $endTime
    set inputFile (mdfind $fileName | grep -F $fileName)
    set subFile (echo $fileName | gsed -E -e 's/(.mp4|.mkv)/.ass/')
    set subFile (echo "$(dirname $inputFile)/$startTime $subFile" | gsed -e 's/\:/./g')

    ffmpeg -ss $startTime -to $endTime -i "$inputFile" "$subFile"
    ffmpeg -ss $startTime -to $endTime -i "$inputFile" -c copy -c:v libx264 -crf 10 -vf "subtitles='$subFile'" $(echo "$(dirname $inputFile)/$startTime $fileName" | gsed -e 's/\:/./g') -y
end