
function c
    if test -d code
        idea
    else
        code . > /dev/null 2>&1 &
        disown
    end
end

