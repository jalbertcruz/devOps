#!/usr/bin/env bash

yt_files=$(cat a.txt)

for file in $yt_files; do
  echo "Processing $file"
  yt-dlp -j "$file"> out.json
  name=$(jq '.id' out.json --raw-output)
  cat out.json | jq . > $name.json
done
