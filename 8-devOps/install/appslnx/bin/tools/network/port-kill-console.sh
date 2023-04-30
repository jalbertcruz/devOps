#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=port_kill_console
install_port_kill_console() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url=$(curl -s https://api.github.com/repos/treadiehq/port-kill/releases/latest |
    grep browser_download_url | grep port-kill-console-linux | head -n 1 |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing Port kill console..."
  echo "Downloading $url"
  mkdir -p $DEST
  echo -n $url | xargs curl -LO
  mv port-kill-console-linux port-kill-console
  chmod +x port-kill-console
  mv port-kill-console $DEST

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
