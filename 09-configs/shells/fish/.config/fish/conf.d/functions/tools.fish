# function buffer
#     set session (pwd | slugify --stdin)
#     set file_name (echo -n $CURRENT_DATE | slugify --stdin)
#
#     zellij action dump-screen "$HOME/tmp/$file_name-$PANE_INDEX.txt"
#     code "$HOME/tmp/$file_name-$PANE_INDEX.txt"
# end

# function buffer
#     set session (pwd | slugify --stdin)
#     set file_name (echo -n $CURRENT_DATE | slugify --stdin)
#
#     zellij action dump-screen "$HOME/tmp/$file_name-$PANE_INDEX.txt"
#     code "$HOME/tmp/$file_name-$PANE_INDEX.txt"
# end

function merge-yazi-keymap
    set wd (pwd)
    cd $argv[1]
    _merge_tomls keymap-base $argv[2] keymap
    cd $wd
end

function update-yazi-configs
    set wd (pwd)
    cd $argv[1]
    _update_tomls $argv[2] $argv[3] $argv[4]
    cd $wd
end

function mkcd
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end

function tempe
    set nd (mktemp -d)
    cd $nd
    chmod -R 0700 .
end

function serveit
    set port 8000
    if test (count $argv) -ge 1
        set port $argv[1]
    end
    python3 -m http.server $port
end

function pretty-path
    echo "$PATH" | sed 's/:/\
/g'
end

function pretty-path-sorted
    pretty-path | sort
end

function two-fa
    set res (printenv | choose -f '=' 0 | rg 'OTP$' | fzf)
    if [ "$res" ]
        while true
            oathtool --totp -b $$res
            sleep 7
        end
    end
end

function format-fish-files
    for f in (fd --search-path $HOME/.config/fish --type file --extension fish)
        echo "Formatting $f"
        fish_indent -w $f
    end
end
