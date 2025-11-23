#!/usr/bin/env bash
IFS=$'\n\t'

export TMP_DIR="$(mktemp -d)"
echo $TMP_DIR
trap 'rm -rf "$TMP_DIR"' EXIT

export UPDATE_ALL=true

#export REFERENCE_DIR_PATH="8-devOps/install"
export BASE_INSTALL_DIR=$HOME
#export BASE_INSTALL_DIR="$HOME/Downloads/aa/temp2"
export FISH_COMPLETIONS_DIR="$HOME/.config/fish/completions/"
export MAN_PAGES_DIR="$HOME/src/devOps/1-cli/local-man-pages/man1/"

#export FISH_COMPLETIONS_DIR="$HOME/Downloads/kdl/temp/"
mkdir -p $FISH_COMPLETIONS_DIR
export STATUS_RESULT_FILE=$HOME/src/apps-installed/status.txt
export FILES_INSTALLED_PATH=$HOME/src/apps-installed
mkdir -p $FILES_INSTALLED_PATH
export WAITING_TIME=5

GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
export PREFIX_PATH="$GIT_ROOT_DIR/$REFERENCE_DIR_PATH"

options=(
  linux
  tui
  searchers
  devops
  "devops-formats"
  utils
  offline
  data
  db
  lua
  web
  bash
  js
  tracing
)
options1=(
  "http-api"
  "http-client"
  "grpc-client"
  protobuf
)
options2=(
  "dev-docs"
  recording
  writing
  learning
  video
  image
  audio
  linter
)
options3=(
  neovim
  refactoring
  performance
  git
  python
)
options4=(
  monitoring
  process
  network
  #  keycloak
  security
)

options5=(
  offline
)

options9=(
  security_1
  clojure
  devops_1
  devops_extra
  EXTRA
  network_1
  tui_1
  tracing_1
  "clangd-lsp"
  #   minio
  #  "clangd-lsp-indexing-tools"
)

# Array of array names
all_options=(
  options
  options1
  options2
  options3
  options4
  options9
  #        options5
)

for array_name in "${all_options[@]}"; do
  eval "current_array=(\"\${${array_name}[@]}\")"
  for item in "${current_array[@]}"; do
    echo "$array_name: $item"
    export APP_TYPE="$item"
    ./install.sh
  done
done

# rg then | rg APP_TYPE | awk '{print $5}' | sort | uniq > types.txt
