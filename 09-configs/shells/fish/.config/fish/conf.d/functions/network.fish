function loopback_exists_at_address
    set -l a (ip addr show dev lo | grep "$argv[1]" || true | tr -d '[:space:]')
    echo $a
end

function vault_create_network
    for loopback_address in "127.0.0.2" "127.0.0.3"
        printf "\n%s" \
            "Enabling local loopback on: $loopback_address"
        sudo ip addr add "$loopback_address"/8 dev lo label lo:1
    end
end

function vault_delete_network
    for loopback_address in "127.0.0.2" "127.0.0.3"
        set -l loopback_exists (loopback_exists_at_address $loopback_address)
        if [ $loopback_exists != "" ]
            printf "\n%s" \
                "Removing local loopback address: $loopback_address"
            sudo ip addr del "$loopback_address"/8 dev lo
        end
    end
end

# function chp
#   # How to check the listening ports and applications on Linux:
#   lsof -wni "tcp:$argv[1]"
# end

function chkp
    sudo lsof -wni "tcp:$argv[1]" | hck -f2 | tail -n +2 | sudo xargs kill -9
end

function fport
    # fuzzy search for ports
    sudo lsof -i -P -n | fzf --bind 'ctrl-r:reload(lsof -i -P -n)' \
        --header 'Press CTRL-R to reload' --header-lines=1 \
        --height=50% --layout=reverse | hck -f2 | tr -d "\n" | xclip -sel clip

end

function kill-port
    # fuzzy search for ports and kill the process
    # lsof -i -P -n | fzf | hck -f2 | tr -d "\n" | xclip -sel clip
    sudo lsof -i -P -n | fzf --bind 'ctrl-r:reload(lsof -i -P -n)' \
        --header 'Press CTRL-R to reload' --header-lines=1 \
        --height=50% --layout=reverse | hck -f2 | tr -d "\n" | xargs kill -9
end

function download-site
    set url (xclip -o -selection clipboard)
    wget --mirror --convert-links --adjust-extension --page-requisites --level=$argv[1] $url
end

function w-intercept-select
    set res (ps -e -o pid,comm,cmd | fzf | hck -f3 | tr -d "\n")
    #set res (ps -e -o pid,comm,cmd | fzf | hck -f2 | tr -d "\n")
    if [ "$res" ]
        echo "Running mitmweb --mode local:$res"
        sudo mitmweb --mode "local:$res"
    end
end

function w-intercept
    set name curl
    set port 8081
    if test (count $argv) -ge 2
        set name $argv[1]
        set port $argv[2]
    end
    sudo mitmweb --mode local:$name --set web_port=$port
end

function intercept
    set name curl
    if test (count $argv) -ge 1
        set name $argv[1]
    end
    sudo mitmproxy --mode local:$name
end

function intercept-all
    sudo mitmproxy --mode local
end
