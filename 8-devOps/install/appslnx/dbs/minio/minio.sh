#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=minio
install_minio() {
  mkdir -p $DEST
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  echo "📥 Installing minio..."
  wget https://dl.min.io/aistor/minio/release/linux-amd64/minio
  #  wget "https://dl.min.io/server/minio/release/linux-amd64/minio"
  chmod +x minio
  #  wget "https://dl.min.io/client/mc/release/linux-amd64/mc"
  wget https://dl.min.io/aistor/mc/release/linux-amd64/mc
  chmod +x mc
  echo "Moving minio files to $DEST"
  mv minio $DEST
  mv mc $DEST
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "minio" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
fi
