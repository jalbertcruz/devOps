
function kbn
  # kill all process by name!
  ps aux | grep $argv[1] | grep -v grep | hck -f2 | sudo xargs kill
end

function fpsk
  set res (ps aux | fzf | hck -f2 | tr -d "\n")
  if [ "$res" ]
      kill -9 $res
  end
end

function fps
  set res (ps aux | fzf | hck -f2 | tr -d "\n")
  if [ "$res" ]
     echo $res | xclip -sel clip
  end
end
