#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=chartdb
install_chartdb() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  version=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/chartdb/chartdb/releases/latest | grep tag_name | cut -d '"' -f4)
  url="https://github.com/chartdb/chartdb/archive/refs/tags/${version}.tar.gz"

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing chartdb..."
  echo "Downloading $url"
  wget $url -O chartdb.tar.gz
  tar -xvf chartdb*.tar.gz
  rm -rf chartdb*.tar.gz
  mv chartdb* chartdb
  mv $DEST/node_modules $DEST/.. || true
  rm -Rf $DEST || true
  mkdir -p $DEST
  cp -Rf chartdb/* $DEST
  cp -Rf chartdb/.* $DEST
  mv $DEST/../node_modules $DEST || true

  save_last_installation_log $app_name
}
if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "db" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
