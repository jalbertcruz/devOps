#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

app_name=keycloak
install_keycloak() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/keycloak/keycloak/releases/latest |
    grep browser_download_url | grep .tar.gz | grep -v account | grep -v admin | grep -v api-docs | grep -v ui-shared | grep -v documentation | grep -v asc | grep -v md5 | grep -v sha1 |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing Keycloak..."
  echo "Downloading $url"
  rm -Rf $DEST || true
  mkdir -p $DEST
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  tar -xvf keycloak*.tar.gz
  cp -Rf keycloak*/* $DEST

  save_last_installation_log $app_name
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "keycloak" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi

app_name=keycloak_api_docs
install_keycloak_api_docs() {
  mkdir -p $DEST
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/keycloak/keycloak/releases/latest |
    grep browser_download_url | grep api-docs | grep .zip | grep -v asc | grep -v md5 | grep -v sha1 |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing keycloak api docs..."
  echo "Downloading $url"
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  unzip keycloak-api-docs*.zip
  rm keycloak-api-docs*.zip
  mv keycloak-api-docs* api-docs
  cp -Rf api-docs $DEST

  save_last_installation_log $app_name
}

if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "keycloak" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi

app_name=keycloak_documentation
install_keycloak_documentation() {
  mkdir -p $DEST
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/keycloak/keycloak/releases/latest |
    grep browser_download_url | grep documentation | grep .zip | grep -v account | grep -v admin | grep -v api-docs | grep -v ui-shared | grep -v asc | grep -v md5 | grep -v sha1 |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing keycloak documentation..."
  echo "Downloading $url"
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  unzip keycloak-documentation*.zip
  rm keycloak-documentation*.zip
  mv keycloak-documentation* documentation
  cp -Rf documentation $DEST

  save_last_installation_log $app_name
}
if (
  [[ ! $(command -v $app_name) ]] ||
    [[ "$UPDATE_ALL" = "true" ]]
) &&
  [[ "$APP_TYPE" = "keycloak" ]]; then
  echo "Installing ${app_name} in: $DEST"
  eval install_$app_name
  wait_some_time $WAITING_TIME "Waiting for $WAITING_TIME seconds before the next script..."
fi
