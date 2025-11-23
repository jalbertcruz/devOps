#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=mitmproxy
install_mitmproxy() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  version=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/mitmproxy/mitmproxy/releases/latest |
    grep tag_name | cut -d '"' -f4)
  echo "version: $version"
  version="${version:1}"
  url="https://downloads.mitmproxy.org/${version}/mitmproxy-${version}-linux-x86_64.tar.gz"

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing mitmproxy..."
  mkdir -p $DEST
  wget $url
  tar -xvf mitmproxy*linux-x86_64.tar.gz
  maybe_copy_fish_completions_files
  maybe_copy_man_pages_files
  mv mitmproxy $DEST
  mv mitmdump $DEST
  mv mitmweb $DEST

  save_last_installation_log $app_name
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "network" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name

  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."

fi
