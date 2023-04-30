#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=async_profiler
install_async_profiler() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/async-profiler/async-profiler/releases/latest |
    grep browser_download_url | grep linux-x64.tar.gz | head -n 1 |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing async-profiler..."
  echo "Downloading $url"
  mkdir -p $DEST
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  tar -xvf async-profiler*linux-x64.tar.gz

  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/async-profiler/async-profiler/releases/latest |
    grep browser_download_url | grep async-profiler.jar | head -n 1 |
    cut -d '"' -f4)
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  mv async-profiler.jar async-profiler*linux*/lib/

  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/async-profiler/async-profiler/releases/latest |
    grep browser_download_url | grep jfr-converter.jar | head -n 1 |
    cut -d '"' -f4)
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  mv jfr-converter.jar async-profiler*linux*/lib/

  cp -rf async-profiler*linux*/* $DEST

  save_last_installation_log $app_name
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "performance" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
