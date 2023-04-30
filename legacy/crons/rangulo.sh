#!/usr/bin/env bash


ffmpeg -y -i  https://icecast.teveo.cu/hmVcdgM7 -codec:a libmp3lame -qscale:a 9 /home/a/audio/angulo.mp3 &

process_pid=$!
base=/home/a/logs/
pid_file_name=rangulo_pid.txt
rm -f $base$pid_file_name
echo $process_pid >> $base$pid_file_name

#ffmpeg -y -i  https://icecast.teveo.cu/XRHCz9jx -codec:a libmp3lame -qscale:a 9 /home/a/audio/juvenil.mp3
