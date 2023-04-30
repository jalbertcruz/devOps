#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
STRIPPED_DIR="${SCRIPT_DIR#"$PREFIX_PATH"}"
DEST="$BASE_INSTALL_DIR$STRIPPED_DIR"

# shellcheck disable=SC1091
source ./_scripts-helper 2>/dev/null || source _scripts-helper 2>/dev/null

app_name=liquibase
install_liquibase() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/liquibase/liquibase/releases/latest |
    grep browser_download_url | grep .tar.gz |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "📥 Installing liquibase..."
  echo "Downloading $url"
  rm -Rf $DEST || true
  mkdir -p $DEST
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  tar -xvf liquibase*.tar.gz
  rm -rf liquibase*.tar.gz
  rm -rf internal/extensions
  cp -Rf $TMP_DIR/$app_name/* $DEST

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

app_name=cassandra_jdbc_wrapper
install_cassandra_jdbc_wrapper() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  echo "📥 Installing cassandra-jdbc-wrapper..."
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/ing-bank/cassandra-jdbc-wrapper/releases/latest |
    grep browser_download_url | grep .jar |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "Downloading $url"
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  cp *.jar $DEST/internal/lib

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

app_name=liquibase_cassandra
install_liquibase_cassandra() {
  mkdir -p "$TMP_DIR/$app_name"
  cd "$TMP_DIR/$app_name"
  echo "📥 Installing liquibase-cassandra..."
  url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/liquibase/liquibase-cassandra/releases/latest |
    grep browser_download_url | grep .jar | grep -v javadoc | grep -v sources | grep -v asc | grep -v md5 | grep -v sha1 |
    cut -d '"' -f4)

  result=$(save_last_version $app_name "$url")
  if [[ "$result" == "skip" ]]; then
    echo "$app_name is already installed with the latest version."
    exit 0
  fi

  echo "Downloading $url"
  echo -n $url | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -LO
  cp *.jar $DEST/internal/lib

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
