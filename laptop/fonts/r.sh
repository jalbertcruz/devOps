#!/usr/bin/env bash

declare -a fonts=(
  .fonts
  FiraCode
  Mononoki
  SourceCodePro
)

for fontFolder in "${fonts[@]}"; do
    zip_file="${font}.zip"
    ls $fontFolder/*.ttf | while read line; do
        ttx "$line"
    done
done

