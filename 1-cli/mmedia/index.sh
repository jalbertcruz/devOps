#!/usr/bin/env bash

set -e

data=$(jq -r 'to_entries' paths.json)

while IFS= read -r -d $'\0' user_json; do
  key=$(echo "$user_json" | jq -r .key)
  path=$(echo "$user_json" | jq -r .value)
  gocatcli index --ignore='**/*.go' --ignore='**/*.md' --ignore='**/.git/**' --ignore='**/.git' \
  --ignore='**/*.jpg' \
  --ignore='**/*.nxml' \
  --ignore='**/target/**' --ignore='**/target' --ignore='**/project/**' \
  --ignore='**/*.py' --ignore='**/*.scala' --ignore='**/*.class' --ignore='**/*.html' \
  "$path" "$key"
done < <(echo $data | jq --raw-output0 '.[]')
