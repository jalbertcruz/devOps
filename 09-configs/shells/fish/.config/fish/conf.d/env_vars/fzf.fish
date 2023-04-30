# fish_add_path --global $HOME/.fzf/bin

# fzf
set -x FZF_DEFAULT_COMMAND 'command fd --type f --color=never --hidden -E .git -E .bsp -E target -E .idea -E .venv'
set -x FZF_DEFAULT_OPTS '--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b,selected-bg:238,selected-fg:146,current-fg:189 --highlight-line --border --multi --info inline-right --layout reverse --marker ▏ --pointer ▌ --prompt '▌ ''

set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_CTRL_T_OPTS "--preview 'bat --color=always --line-range :50 {}'"

set -x FZF_ALT_C_COMMAND 'command fd --type d . --color=never --hidden -E .git -E .bsp -E target -E .idea -E .venv'
set -x FZF_ALT_C_OPTS "--preview 'tree -C {} | head -50'"
# set -x FZF_COMPLETION_TRIGGER '**'

set -x FZF_COMPLETION_PATH_OPTS "--walker=file,dir,hidden"
set -x FZF_COMPLETION_DIR_OPTS "--walker=dir,hidden"

fish_add_path --global $HOME/appslnx/tools/git/git-fuzzy/bin
