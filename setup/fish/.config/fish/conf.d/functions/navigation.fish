
# test -e .env.local && envsource .env.local
#     test -d code && wezterm cli spawn --cwd code --

function react_to_pwd --on-variable PWD
    test -e .cs-java && set jsJava (cat .cs-java) && eval "$(cs java --jvm  $jsJava --env)"
    type -q deactivate && deactivate
#     set activate_path .venv/bin/activate.fish
#     if test -e $activate_path
#         echo "Activating virtualenv: $PWD/$activate_path"
#         source "$PWD/$activate_path"
#     end
end

function ch
    set dest (_choose-destination)
    cd "$dest"
end

function rgf
  set res (rg $argv[1] > /dev/null; and rg $argv[1] --json | ripgrep_to_fzf_filter --rb 3 --lc 6 \
  | fzf --delimiter : --preview 'bat --color=always {1} --line-range {4}:+{5} --highlight-line {2} --wrap=character --terminal-width=80' \
  | hck -Ld':' -f1,2,3 -D=":")
  if [ "$res" ]
      command code --reuse-window --goto $res > /dev/null &
      disown
  end
end

function rgfnv
  set res (rg $argv[1] > /dev/null; and rg $argv[1] --json | ripgrep_to_fzf_filter --rb 3 --lc 6 \
  | fzf --delimiter : --preview 'bat --color=always {1} --line-range {4}:+{5} --highlight-line {2} --wrap=character --terminal-width=80')
  if [ "$res" ]
      echo -n $res | _vim-translator | xargs nvim
  end
end
