
# test -e .env.local && envsource .env.local
#     test -d code && wezterm cli spawn --cwd code --

function react_to_pwd --on-variable PWD
    type -q deactivate && deactivate
    test -e .venv/bin/activate.fish && source .venv/bin/activate.fish
end

function ch
    set dest (_choose-destination)
    cd "$dest"
end

function rgf
  set res (rg $argv[1] > /dev/null; and rg $argv[1] --json | ripgrep_to_fzf_filter --rb 3 --lc 6 \
  | fzf --delimiter : --preview 'bat --color=always {1} --line-range {4}:+{5} --highlight-line {2} --wrap=character --terminal-width=80' \
  | hck -Ld':' -f1,2,3 -D=":")
  rg $argv[1] > /dev/null; and command code --reuse-window --goto $res &
  disown
end

function rgfnv
  rg $argv[1] > /dev/null; and rg $argv[1] --json | ripgrep_to_fzf_filter --rb 3 --lc 6 \
  | fzf --delimiter : --preview 'bat --color=always {1} --line-range {4}:+{5} --highlight-line {2} --wrap=character --terminal-width=80' \
  | _vim-translator | xargs nvim
end
