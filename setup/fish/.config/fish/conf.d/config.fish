
# Configure Jump
status --is-interactive; and source (jump shell fish | psub)

fish_vi_key_bindings

set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
source /usr/share/powerline/bindings/fish/powerline-setup.fish

source ~/.config/fish/conf.d/env_vars.fish
source ~/.config/fish/conf.d/functions.fish
source ~/.config/fish/conf.d/aliases.fish

#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# set -x NVM_DIR "$HOME/.nvm"
# bass source "$NVM_DIR/nvm.sh" ';' # This loads nvm

#bass source ~/.nvm/nvm.sh --no-use ';' 

# function nvm
  # nvm $argv
# end

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always
set -gx TERM xterm-256color

powerline-setup

set -g fish_greeting
# set -g IDEA_PROPERTIES '/usr/local/bin/appslnx/jetbrains/idea/personal/idea.properties'


set -x LD_LIBRARY_PATH /usr/local/lib/

# source /media/a/data/installers/Unix/CLI-tools/tmuxinator/completion/tmuxinator.fish

# https://github.com/rbenv/rbenv
# set -x fish_user_paths $HOME/.rbenv/bin $fish_user_paths
# status --is-interactive; and source (rbenv init -|psub)

# set -x PATH $HOME/appslnx/bin/job $PATH
penv

direnv hook fish | source

# bind \cr history-token-search-backward
# bind \cn history-token-search-forward
# bind \cg "commandline -rt (complete -C --escape|fzf|cut -d\t -f1)\ "

# Fish syntax highlighting
set -g fish_color_autosuggestion '555' 'brblack'
set -g fish_color_cancel -r
set -g fish_color_command --bold
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end brmagenta
set -g fish_color_error brred
set -g fish_color_escape 'bryellow' '--bold'
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection brblue
set -g fish_color_search_match 'bryellow' '--background=brblack'
set -g fish_color_selection 'white' '--bold' '--background=brblack'
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

# Install Starship
starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source
