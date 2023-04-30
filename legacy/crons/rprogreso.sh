#!/usr/bin/env bash

day=$(date +%d)
month=$(date +%b)
year=$(date +"%Y")

ffmpeg -y -i  https://icecast.teveo.cu/XjfW7qWN -codec:a libmp3lame -qscale:a 9 "/home/a/audio/clave830-$day-$month-$year.mp3" &

process_pid=$!
base=/home/a/logs/
pid_file_name=rprogreso_pid.txt
rm -f $base$pid_file_name
echo $process_pid >> $base$pid_file_name
