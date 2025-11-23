#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=hck
install_hck() {
  mkdir -p $DEST
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  echo "📥 Installing hck..."
  wget https://github.com/sstadick/hck/releases/latest/download/hck-linux-amd64
  mv hck-linux-amd64 hck
  chmod +x hck
  maybe_copy_fish_completions_files
  maybe_copy_man_pages_files
  mv hck $DEST
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "utils" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
