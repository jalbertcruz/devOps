set -gx VOLTA_HOME /media/z/data/repo/internet2/volta
fish_add_path --global "$VOLTA_HOME/bin"
fish_add_path --global "$HOME/appslnx/tools/nodejs/volta/bin"
fish_add_path --global "$HOME/appslnx/tools/nodejs/apps/bin"
fish_add_path --global "$HOME/appslnx/tools/nodejs/apps/bootstrap"

# source ~/.asdf/asdf.fish

# not more ruby
# status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

set -xg GPG_TTY (tty)

# if test -e ~/.env
# #     echo ".env exists, sourcing it"
#     envsource ~/.env
# # else
# #     echo "File does not exist"
# end

# if test -e ~/.config/fish/conf.d/config.fish
#     source ~/.config/fish/conf.d/config.fish
# end

# test -d code && wezterm cli spawn --cwd code --
# test -e .venv/bin/activate.fish && source .venv/bin/activate.fish

set -gx DENV 1

# function ljava # --no-scope-shadowing
#     set val (eval (cat .cs-java))
#     echo $val
#     eval "$val"
# end

# fish_add_path --global $HOME/.basher/bin
# status --is-interactive; and . (basher init - fish | psub)    ##basher5ea843

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
fish_add_path --global $HOME/.cabal/bin
fish_add_path --global $HOME/.ghcup/bin # ghcup-env

# Added by LM Studio CLI (lms)
fish_add_path --global $HOME/.lmstudio/bin
