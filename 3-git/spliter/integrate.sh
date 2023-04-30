#!/usr/bin/env bash

# exit when any command fails
set -e

shopt -s dotglob
shopt -s lastpipe

#cat rps.json | jq '.repos | [.[].home]' | jq -r '.[]' | readarray -t repos
#cat rps.json | jq '.repos | [.[].name]' | jq -r '.[]' | readarray -t names
#cat rps.json | jq '.repos | [.[].branch]' | jq -r '.[]' | readarray -t branches

readarray -t repos < <(cat rps.json | jq '.repos | [.[].home]' | jq -r '.[]')
readarray -t names < <(cat rps.json | jq '.repos | [.[].name]' | jq -r '.[]')
readarray -t branches < <(cat rps.json | jq '.repos | [.[].branch]' | jq -r '.[]')


temp_dir=$(cat rps.json | jq -r '.temp_dir')
destination=$(cat rps.json | jq -r '.destination')

if [ ! -d "$temp_dir" ]
then
    echo "do not exists"
    mkdir -p "$temp_dir"
fi

if [ ! -d "$destination" ]
then
    echo "do not exists"
    mkdir -p "$destination"
fi

cd "$destination"
git init && git commit --allow-empty -m 'Initial commit' && git co -b dev

for i in "${!repos[@]}"; do
  cd "$temp_dir"

  rm -Rf "${names[$i]}"
  git clone --branch "${branches[$i]}" "${repos[$i]}" "${names[$i]}"
  cd "$temp_dir/${names[$i]}"

  for f in *; do
    git filter-repo --path-rename "$f:${names[$i]}/$f"
  done

  git checkout -b "${names[$i]}"

  cd "$destination"
  git remote add -f "${names[$i]}" "$temp_dir/${names[$i]}"

  git merge "${names[$i]}/${branches[$i]}" --allow-unrelated-histories -m "Adding ${names[$i]}"

done
