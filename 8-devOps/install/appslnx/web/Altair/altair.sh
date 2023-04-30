#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=altair
install_altair() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url1=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/altair-graphql/altair/releases/latest |
    grep browser_download_url | grep 86_64_linux.AppImage | head -n 1)
  url=$(echo -n $url1 | cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing Altair..."
  echo "Downloading $url"
  rm -Rf $DEST/squashfs-root || true
  mkdir -p $DEST
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  mv altair*.AppImage altair.AppImage
  chmod +x altair.AppImage
  ./altair.AppImage --appimage-extract
  mv -f squashfs-root $DEST

  save_last_installation_log $app_name
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "http-client" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
