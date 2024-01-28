
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
  lsof -wni "tcp:$argv[1]" | hck -f2 | tail -n +2 | sudo xargs kill -9
end

function fports
    # fuzzy search for ports and copy the PID to clipboard
    lsof -wni | fzf | hck -f2 | tr -d "\n" | xclip -sel clip
end

