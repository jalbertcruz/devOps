
function tid
  # https://www.shell-tips.com/linux/how-to-format-date-and-time-in-linux-macos-and-bash/
  date '+%Y%m%d%H%M%S'
end

# Multimedias
function mp3-tag
    # https://eyed3.readthedocs.io/en/latest/
    for i in *.mp3
      eyeD3 -a $argv[1] -n 2 "$i" -t "$i"
    end
end

function mp3-split
    #  mp3-split <file> 900
    ffmpeg -i $argv[1] -f segment -segment_time $argv[2] -c copy %02d-$argv[1].mp3
end

function mp4-to-mp3
    ffmpeg -i $argv[1] -b:a 192K -vn $argv[1].mp3
end

function media-clean
    auto-editor $argv[1]
end

# Development

function c
    code . > /dev/null 2>&1 &
    disown
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

function der
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

function structurizr
  java -Djdk.util.jar.enableMultiRelease=false \
    -jar "/media/a/data/docs/P/Architecture/best/!! Software Architecture for Developers/tools/structurizr-lite.war" $argv[1]
end

function ltxp
#     docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pdflatex $argv[1].tex
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2023-06-01 pdflatex $argv[1].tex
end

function venv
  # set -l options (fish_opt -s h -l help)
  set -l options (fish_opt -s v -l python_version --required-val)
  argparse $options -- $argv

  if not set -q _flag_v
    echo "The Python version must be specified"
    return 2
  end

  eval "python$_flag_v -m venv .venv"

  source .venv/bin/activate.fish

  pip install --upgrade pip
  pip install --upgrade wheel

  test -e requirements.txt && pip install -r requirements.txt
  test -e Pipfile && pipenv install --dev

end

function sbtr
    sleep $argv[1] && sbt -Dactive.app="$argv[2]" -Dconfig.file="$argv[3]" r
end

## Kubernetes

function kctl
  if count $argv > /dev/null
    switch $argv[1]
        case cli
          set name (kubectl get pods | grep $argv[2] | head -n 1 | awk '{print $1}')
          kubectl exec --stdin --tty $name -- /bin/bash
      case logs
          set name (kubectl get pods | grep $argv[2] | head -n 1 | awk '{print $1}')
          kubectl logs $name -f
     case pf
          set name (kubectl get pods | grep $argv[2] | head -n 1 | awk '{print $1}')
          kubectl port-forward $name "$argv[3]:$argv[3]"
    end
  else
      kubectl get pods -o wide
  end

end

# function vpnc
#   sudo openfortivpn
# end

# function make
#   if set -q MAKE_FILE
#       /usr/bin/make -f $MAKE_FILE $argv
#   else
#       /usr/bin/make $argv
#   end
# end

# Documentation
function ltxx
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 xelatex $argv[1].tex
    # docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 pst-pdf $argv[1].tex
    docker run --rm -it -v (pwd):/workdir danteev/texlive:2022-02-15 lualatex --shell-escape $argv[1].tex
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

test -e .venv/bin/activate.fish && source .venv/bin/activate.fish
# test -e .env.local && envsource .env.local

function react_to_pwd --on-variable PWD
    type -q deactivate && deactivate
    test -e .venv/bin/activate.fish && source .venv/bin/activate.fish
#    test -e .env.local && envsource .env.local
end

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
# OS and System
function kbn
  # kill all process by name!
  ps aux | grep $argv[1] | grep -v grep | awk '{print $2}' | sudo xargs kill
end

function kjp
    ps aux | grep java | grep $argv[1] | grep -v grep | awk '{print $2}' | xargs kill
end

function chp
  # How to check the listening ports and applications on Linux:
  sudo lsof -wni "tcp:$argv[1]"
end

function chkp
  sudo lsof -wni "tcp:$argv[1]" | awk '{print $2}' | awk 'NR!=1' | sudo xargs kill -9
end

