
function kbn
  # kill all process by name!
  ps aux | grep $argv[1] | grep -v grep | hck -f2 | sudo xargs kill
end

function kps
    ps aux | fzf | hck -f2 | tr -d "\n" | xargs kill -9
end

function fps
    ps aux | fzf | hck -f2 | tr -d "\n" | xclip -sel clip
end
