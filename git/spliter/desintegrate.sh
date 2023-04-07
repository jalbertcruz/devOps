#!/usr/bin/env bash

# exit when any command fails: https://intoli.com/blog/exit-on-errors-in-bash-scripts
set -e

shopt -s dotglob
shopt -s lastpipe

# https://www.baeldung.com/linux/reading-output-into-array
#cat drps.json | jq '.repos | [.[].home]' | jq -r '.[]' | readarray -t repos
#cat drps.json | jq '.repos | [.[].name]' | jq -r '.[]' | readarray -t names

readarray -t repos < <(cat drps.json | jq '.repos | [.[].home]' | jq -r '.[]')
readarray -t names < <(cat drps.json | jq '.repos | [.[].name]' | jq -r '.[]')

source_repo=$(cat drps.json | jq -r '.source_repo')
destination=$(cat drps.json | jq -r '.destination')
branch=$(cat drps.json | jq -r '.branch')

if [ ! -d $destination ]; then
  echo "do not exists"
  mkdir -p $destination
fi

cd $destination

for i in "${!repos[@]}"; do

  rm -Rf "${repos[$i]}"
  git clone --no-local --branch $branch $source_repo "${repos[$i]}"

  cd "${repos[$i]}"

  git filter-repo --path "${names[$i]}"

  cd "${names[$i]}"

  for f in *; do
    cd ..

    git filter-repo --path-rename "${names[$i]}/$f:$f"
    cd "${names[$i]}" || true
  done

  cd ..

done

