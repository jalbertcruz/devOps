# test -e .env.local && envsource .env.local
#     test -d code && wezterm cli spawn --cwd code --

function react_to_pwd --on-variable PWD
    #     test -e .cs-java && set jsJava (cat .cs-java) && eval "$(cs java --jvm  $jsJava --env)"
    #     set xxx "$(cs java --jvm 17 --env | sd 'set -x' 'set -gx')"
    #     eval $xxx

    echo changing directory to $PWD

    #     check_directory_for_new_repository

    if not test -e .cs-java
        #         test -d ~/appslnx/jdk-17 && set -x JAVA_HOME ~/appslnx/jdk-17
        test -d ~/appslnx/jdk-21 && set -x JAVA_HOME ~/appslnx/jdk-21
    else
        set jsJava (cat .cs-java)
        echo Setting JDK version to $jsJava
        set x "$(cs java --jvm $jsJava --env)"
        #         eval "$x"
    end

    type -q deactivate && deactivate
    #     set activate_path .venv/bin/activate.fish
    #     if test -e $activate_path
    #         echo "Activating virtualenv: $PWD/$activate_path"
    #         source "$PWD/$activate_path"
    #     end
end

function rgf
    set res (rg $argv[1] > /dev/null; and rg $argv[1] --json | ripgrep_to_fzf_filter --rb 3 --lc 6 \
  | fzf --delimiter : --preview 'bat --color=always {1} --line-range {4}:+{5} --highlight-line {2} --wrap=character --terminal-width=80' \
  | hck -Ld':' -f1,2,3 -D=":")
    if [ "$res" ]
        command code --reuse-window --goto $res >/dev/null &
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

# dirs-navigator
# senv
function ch
    #   set dest (_choose-destination)
    set dest (_choose-project)
    #   set dest (_senv)
    if [ "$dest" ]
        z "$dest"
    end
end

function fcd
    #   set res (find . -type d -not -path '*/.*' | fzf)
    set res (fd --type d | fzf)
    if [ "$res" ]
        z $res | l
    end
end

function fdc
    #   set res (find . -type d -not -path '*/.*' | fzf)
    set res (fd --type d | fzf)
    if [ "$res" ]
        set current (pwd)
        z "$res"
        pwd | tr -d "\n" | xclip -sel clip
        z "$current"
    end
end

function fv
    #   set res (find . -type f -not -path '*/.*' | fzf)
    set res (fd --type f | fzf)
    if [ "$res" ]
        nvim $res
    end
end

# https://github.com/o2sh/onefetch/wiki/getting-started
# function cd -w='cd'
#   builtin cd $argv || return
#   check_directory_for_new_repository
# end

function check_directory_for_new_repository
    set current_repository (git rev-parse --show-toplevel 2> /dev/null)
    if [ "$current_repository" ] && [ "$current_repository" != "$last_repository" ]

        ## git repo description...
        #     onefetch

    end
    set -gx last_repository $current_repository
end

# funcsave cd
# funcsave check_directory_for_new_repository
# check_directory_for_new_repository

function yv
    touch ~/.config/yazi/yazi.mark
    set mark (cat ~/.config/yazi/yazi.mark)
    if test "$mark" != yv
        echo "setting yazi mark to yv"
        echo yv >~/.config/yazi/yazi.mark
        update-yazi-configs ~/.config/yazi yazi-base yazi-preview yazi
    end
    y_canonical
end

function y
    touch ~/.config/yazi/yazi.mark
    set mark (cat ~/.config/yazi/yazi.mark)
    if test "$mark" != y
        echo "setting yazi mark to y"
        echo y >~/.config/yazi/yazi.mark
        update-yazi-configs ~/.config/yazi yazi-base yazi-0 yazi
    end
    y_canonical
end

function y_canonical
    # https://yazi-rs.github.io/docs/quick-start#shell-wrapper
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function format-local-binaries
    set items "$HOME/src/devOps/09-configs/base/bin/" \
        "$HOME/src/devOps/09-configs/data/bin/" \
        "$HOME/src/devOps/09-configs/dev/bin/" \
        "$HOME/src/devOps/09-configs/lnx-utils/bin/" \
        "$HOME/src/devOps/09-configs/Ops/bin/" \
        "$HOME/src/devOps/09-configs/study/bin/"

    for i in $items
        shfmt -i 2 -l -w $i/*
    end
    shfmt -i 2 -l -w $HOME/src/devOps/09-configs/bootstrap
end

function fbs
    set items "$HOME/src/devOps/09-configs/base/bin/" \
        "$HOME/src/devOps/09-configs/data/bin/" \
        "$HOME/src/devOps/09-configs/dev/bin/" \
        "$HOME/src/devOps/09-configs/lnx-utils/bin/" \
        "$HOME/src/devOps/09-configs/Ops/bin/" \
        "$HOME/src/devOps/09-configs/study/bin/"

    set combined (string collect (for i in $items
       fd --search-path $i --type file
    end))

    set name (for i in $combined
        echo $i
    end | xargs -I{} basename '{}' | fzf)

    if [ "$name" ]
        set combined2 (string collect (for i in $items
       fd --search-path $i --type file "$name"
    end))

        if test (count $combined2) -gt 0
            set name (for i in $combined2
            echo $i
        end | head -n 1)
            nvim $name
        end
    end

end

function ffs
    set res (functions -n | fzf --preview 'type {}')
    if [ "$res" ]
        eval $res
    end
end
