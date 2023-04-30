#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"

DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=envconsul
install_envconsul() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  version=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/hashicorp/envconsul/releases/latest |
    grep tag_name | cut -d '"' -f4)
  version="${version:1}"
  url="https://releases.hashicorp.com/envconsul/${version}/envconsul_${version}_linux_amd64.zip"

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing envconsul..."
  echo "Downloading envconsul from: $url"
  mkdir -p $DEST
  echo -n $url | xargs curl -LO
  unzip envconsul*inux_amd64.zip
  maybe_copy_fish_completions_files
  mv envconsul $DEST

  save_last_installation_log $app_name
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "devops_1" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
