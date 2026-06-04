#!/opt/homebrew/bin/fish
for file in (fd . -e ".md")
    touch -r "$file" "$file.timestamp" 
		sd "```dynbedded\n\[\[Heading Template\]\]\n```" "" "$file"
    touch -r "$file.timestamp" "$file"
    rm "$file.timestamp"
end
