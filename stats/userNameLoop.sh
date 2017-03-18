#!bin/bash
# will show the stats (format .json) for line modified for every file type.
# just type "sh userNameLoop.sh" in the repository
# or "bash userNameLoop.sh" in the repository
echo "Starting..."

IFS=$'\n'
for user in $(git shortlog -sn | grep -oP '(?:\s\K)(\D+)(?=$)'); do 
    a="$user"
    a+="_numStat.txt"
    echo "Processing user $user"
    git log --numstat --author="$user" --oneline > "$a"
    node parser_git_stats.js "$a"
    rm "$a"
done