#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=jq
install_jq() {
  mkdir -p $DEST
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  echo "📥 Installing jq..."
  wget https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64
  mv jq-linux-amd64 jq
  chmod +x jq
  mv jq $DEST
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "data" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
