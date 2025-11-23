function c
    if test -d code
        idea
    else
        code . >/dev/null 2>&1 &
        disown
    end
end

function check-nl
    fd --full-path --type f --hidden --exclude .git/ --exec bash -c 'test "$(tail -c1 "$0")" && echo "No newline at end of $0"'
end

function add-nl
    fd --full-path --type f --hidden --exclude .git/ --exec bash -c 'test "$(tail -c1 "$0")" && echo "" >> "$0"'
end

function structurizr
    java -Djdk.util.jar.enableMultiRelease=false \
        -jar /media/z/data/docs/P/Architecture/best/Software-Architecture-for-Developers/tools/structurizr-lite.war $argv[1]
end

function ltxp
    #     docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pdflatex $argv[1].tex
    #docker run --rm -it -v (pwd):/workdir danteev/texlive:2024-08-15 pdflatex $argv[1].tex
    docker run --rm -it -v (pwd):/workdir texlive/texlive:latest pdflatex $argv[1].tex
end

function ltxx
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 xelatex $argv[1].tex
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pst-pdf $argv[1].tex
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 lualatex --shell-escape $argv[1].tex
end

function v
    set nvim_exists (ps aux | rg "nvim --listen /tmp/\(pwd \|" | count)
    if test $nvim_exists -gt 0
        set -l current_value (env | grep "^NVIM_ID=" | cut -d'=' -f2)
        set -l new_value (math "$current_value + 1")
        set -gx NVIM_ID $new_value
        nvim $argv
    else
        set -gx NVIM_ID 0
        nvim --listen "/tmp/(pwd | slugify --stdin)" $argv
    end
end

function update-espanso-templates-path
  set res (yq '.[][0].params.cmd' ~/.config/espanso/match/templates_path.yml | choose 1)
  eval set p $res
 echo -n $ESPANSO_TEMPLATES > $p
end
