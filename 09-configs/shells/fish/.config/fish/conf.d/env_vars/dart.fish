#fish_add_path -g -p <path-to-sdk>/bin
fish_add_path --global $HOME/appslnx/google/flutter/bin
fish_add_path --global $HOME/.pub-cache/bin
fish_add_path --global $HOME/appslnx/google/android/cmdline-tools/bin

set --export ANDROID_HOME $HOME/appslnx/google/android/sdk
fish_add_path --global $ANDROID_HOME/emulator
fish_add_path --global $ANDROID_HOME/tools
fish_add_path --global $ANDROID_HOME/tools/bin
fish_add_path --global $ANDROID_HOME/platform-tools
