#!/usr/bin/env bash
IFS=$'\n\t'

TARGET_DIR="./appslnx"

find "$TARGET_DIR" -type f -name "*.sh" | while read -r script; do
  #  echo "Running script: $script"
  echo "${script} error" >>$STATUS_RESULT_FILE
  bash "$script"
  result_code=$?
  if [[ $result_code -ne 0 ]]; then
    echo "Error running $script"
  else
    sed -i '$d' $STATUS_RESULT_FILE
  fi
done
