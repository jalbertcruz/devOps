#!/usr/bin/env bash

#for f in $(fd); do
#  if [ -f "$f" ]; then
#    check-added-large-files --enforce-all "$f"
#  fi
#done

for f in $(fd); do
  if [ -f "$f" ]; then
    check-case-conflict "$f"

    #    -   id: check-illegal-windows-names
    #    name: check illegal windows names
    #    entry: Illegal Windows filenames detected
    #    language: fail
    #    files: '(?i)((^|/)(CON|PRN|AUX|NUL|COM[\d¹²³]|LPT[\d¹²³])(\.|/|$)|[<>:\"\\|?*\x00-\x1F]|/[^/]*[\.\s]/|[^/]*[\.\s]$)'
    #    check-illegal-windows-names "$f"

    check-merge-conflict "$f"
    check-symlinks "$f"
  fi
done

for f in $(fd --extension py); do
  if [ -f "$f" ]; then
    check-ast "$f"
    check-builtin-literals "$f"
    check-docstring-first "$f"
    #    double-quote-string-fixer "$f"
  fi
done

for f in $(fd --extension py scala --extension js); do
  if [ -f "$f" ]; then
    mixed-line-ending "$f"
    end-of-file-fixer "$f"
    trailing-whitespace-fixer "$f"
  fi
done

for f in $(fd --extension json); do
  if [ -f "$f" ]; then
    check-json "$f"
  fi
done

for f in $(fd --extension toml); do
  if [ -f "$f" ]; then
    check-toml "$f"
  fi
done

for f in $(fd --extension yml yaml); do
  if [ -f "$f" ]; then
    check-yaml "$f"
  fi
done

for f in $(fd --extension json); do
  if [ -f "$f" ]; then
    pretty-format-json"$f"
  fi
done

ruff check --fix
ruff format
