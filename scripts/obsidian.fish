#!/usr/bin/env fish
cd ~/Sync/Obsidian

if test (math "$(date +%s) - $(git log -1 --format=%ct)") -gt 300; and test -n "$(git status -s)"
    git stage .
    if git commit -m "Vault backup $(date '+%Y/%m/%d %I:%M %p')."
        notify-send -t 2000 "Vault changes saved."
    else
        notify-send -t 2000 "Vault changes not saved."
    end
end

git fetch origin main
if test (git rev-list origin/main..HEAD --count) -gt 0
    if git push origin main
        notify-send -t 2000 "Vault changes pushed."
    else
        notify-send -t 2000 "vault changes not pushed."
    end
end
