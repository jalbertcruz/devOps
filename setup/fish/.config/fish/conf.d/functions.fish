function tid
  # https://www.shell-tips.com/linux/how-to-format-date-and-time-in-linux-macos-and-bash/
  date '+%Y%m%d%H%M%S'
end

function mp3tag
    for i in *.mp3
      eyeD3 -a $argv[1] -n 2 "$i"
    end
end

function vpnc
  sudo openfortivpn
end

function mux
  command tmuxinator $argv
end

function lvenv
  source .env/bin/activate.fish
end

function penv
    set -x PATH[2] $HOME/appslnx/bin/dev
end

function jenv
    set -x PATH[2] $HOME/appslnx/bin/job
end

set -gx DEV_ENV LOCAL

function lenv
  set -gx DEV_ENV LOCAL
  direnv reload
end

function denv
  set -e DEV_ENV
  direnv reload
end

set -gx DENV 1

function sdenv
  set -e DENV
  set -gx DENV $argv[1]
  direnv reload
end

function wmock
  java -cp /media/a/data/docs-files/Web/Testing/proxies/wiremock/wiremock/wiremock-jre8-standalone-2.35.0.jar:/media/a/data/docs-files/Web/Testing/proxies/wiremock/wiremock/wiremock-webhooks-extension-2.35.0.jar \
    com.github.tomakehurst.wiremock.standalone.WireMockServerRunner \
    --extensions org.wiremock.webhooks.Webhooks --port $argv[1] --root-dir $argv[2]
end

function ltxp
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pdflatex $argv[1].tex
end

function ltxx
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 xelatex $argv[1].tex
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pst-pdf $argv[1].tex
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 lualatex --shell-escape $argv[1].tex
end

function kabn
  # kill all process by name!
  ps aux | grep $argv[1] | grep -v grep | awk '{print $2}' | xargs kill
end

function kjp
    ps aux | grep java | grep $argv[1] | grep -v grep | awk '{print $2}' | xargs kill
end

function chp
  # How to check the listening ports and applications on Linux:
  sudo lsof -wni "tcp:$argv[1]"
end

function chkp
  # How to check the listening ports and applications on Linux:
  sudo lsof -wni "tcp:$argv[1]" | awk '{print $2}' | awk 'NR!=1' | sudo xargs kill
end

function venv
  # set -l options (fish_opt -s h -l help)
  set -l options (fish_opt -s v -l python_version --required-val)
  argparse $options -- $argv

  if not set -q _flag_v
    echo "The Python version must be specified"
    return 2
  end

  eval "python$_flag_v -m venv .env"

  source .env/bin/activate.fish

  pip install --upgrade pip
  pip install --upgrade wheel

  if test -e requirements.txt
      pip install -r requirements.txt
  end

end

function sbtr
    sleep $argv[1] && sbt r
end

function make
  if set -q MAKE_FILE
      /usr/bin/make -f $MAKE_FILE $argv
  else
      /usr/bin/make $argv
  end
end

# https://gist.github.com/nikoheikkila/dd4357a178c8679411566ba2ca280fcc#file-readme-md
function envsource
  for line in (cat $argv | grep -v '^#')
    set item (string split -m 1 '=' $line)
    if test (string match '"*' $item[2])
        set item2 (string sub -s 2 -e -1 $item[2])
        set -gx $item[1] $item2
#         echo "Exported key $item[1] ==== " $item2
    else
        set -gx $item[1] $item[2]
#         echo "Exported key $item[1] ---> " $item[2]
    end
  end
end

envsource ~/.env
