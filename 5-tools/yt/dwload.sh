#!/usr/bin/env bash

for row in $(jq -c '.[]' pl/output/result.json); do
    ftv_id=$(echo "$row" | jq -r '.ytv_id')
    format_id_video=$(echo "$row" | jq -r '.format_id_video')
    format_id_audio=$(echo "$row" | jq -r '.format_id_audio')
    url="https://www.youtube.com/watch?v=${ftv_id}"
    yt-dlp -f $format_id_audio $url --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters -P ytv/audio
    yt-dlp -f $format_id_video $url --write-description --no-clean-info-json --write-info-json --write-playlist-metafiles --embed-metadata --embed-chapters -P ytv/video
done