#!/usr/bin/env bash
set -e
set -u
set -o pipefail

eval "$(direnv dotenv bash $HOME/.env)"
/usr/local/bin/appslnx/tools/edition/LogseqDB/bin/Logseq %u
