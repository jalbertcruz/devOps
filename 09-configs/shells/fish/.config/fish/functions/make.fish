function make
    if set -q MAKE_FILE
        /usr/bin/make -f $MAKE_FILE $argv
    else
        /usr/bin/make $argv
    end
end
