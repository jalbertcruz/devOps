
function structurizr
  java -Djdk.util.jar.enableMultiRelease=false \
    -jar /media/a/data/docs/P/Architecture/best/Software-Architecture-for-Developers/tools/structurizr-lite.war $argv[1]
end

function ltxp
#     docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pdflatex $argv[1].tex
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2023-06-01 pdflatex $argv[1].tex
end

function ltxx
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 xelatex $argv[1].tex
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pst-pdf $argv[1].tex
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 lualatex --shell-escape $argv[1].tex
end
