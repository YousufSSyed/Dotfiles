#!/usr/bin/fish

set -l folder /path/to/folder
set -l branch main

cd $folder

# Get the last commit timestamp (Unix epoch)
set -l last_commit_time (git log -1 --format=%ct 2>/dev/null)

# If no commits exist, set last_commit_time to 0
if test -z "$last_commit_time"
    set last_commit_time 0
end

# Check if 5 minutes (300 seconds) have passed since the last commit
if test (math "$(date %s) - $last_commit_time") -gt 300
    # Stage all changes
    git stage .

    # Check if there are staged files
    if test -n "(git diff --cached --name-only)"
        # Commit with current date/time
        set -l commit_message "vault backup: (date '+%Y-%m-%d %H:%M:%S')"
        if git commit -m $commit_message
            notify-send "vault changes saved"
        else
            notify-send "vault changes not saved"
        end
    end
end

# Check if remote is up to date
git fetch origin $branch >/dev/null 2>&1
set -l local_sha (git rev-parse @)
set -l remote_sha (git rev-parse @{u})

if test "$local_sha" = "$remote_sha"
    # Remote is up to date, no need to push
    notify-send "vault changes already up to date"
else
    # Push to remote
    if git push origin $branch
        notify-send "vault changes pushed"
    else
        notify-send "vault changes not pushed"
    end
end
