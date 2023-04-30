function kill-by-name
    # kill all process by name!
    ps aux | grep $argv[1] | grep -v grep | hck -f2 | sudo xargs kill -9
end

function find-kill-process --argument-names kill_type
    set res (ps aux | fzf | hck -f2 | tr -d "\n")
    if [ "$res" ]
        # https://linuxhandbook.com/sigterm-vs-sigkill/
        # https://ioflood.com/blog/kill-linux-command/
        # https://www.ic.unicamp.br/~celio/mc514/linux/linux_pgsignals.html
        if test -n "$kill_type"; and test "$kill_type" = k
            echo "doing: kill -9 $res"
            kill -SIGKILL $res
        else
            echo "doing: kill -SIGTERM $res"
            kill -SIGTERM $res
        end
    end
end

function find-process
    set res (ps aux | fzf | hck -f2 | tr -d "\n")
    if [ "$res" ]
        echo $res | xclip -sel clip
    end
end
