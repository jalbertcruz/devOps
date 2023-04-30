#!/usr/bin/env bash

base=/home/a/logs/
pid_file_name=rangulo_pid.txt
cat $base$pid_file_name | xargs -L 1 -I {} kill -9 "{}"