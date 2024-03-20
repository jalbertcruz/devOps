
function fff
  set res (functions -n | fzf --preview 'type {}')
  if [ "$res" ]
    eval $res
  end
end
