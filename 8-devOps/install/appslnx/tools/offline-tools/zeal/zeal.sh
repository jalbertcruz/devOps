#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=zeal
install_zeal() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url1=$(curl -s https://api.github.com/repos/zealdocs/zeal/releases/latest |
    grep browser_download_url | grep x86_64.AppImage | head -n 1)
  url=$(echo -n $url1 | cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing Zeal..."
  echo "Downloading $url"
  mkdir -p $DEST
  echo -n $url | xargs curl -LO
  mv zeal*x86_64.AppImage a.AppImage
  chmod +x a.AppImage
  rm -rf $DEST/squashfs-root || true
  ./a.AppImage --appimage-extract
  cp -R squashfs-root $DEST

  save_last_installation_log $app_name
}
if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "video" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
