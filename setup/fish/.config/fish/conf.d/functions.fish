
function c
    if test -d code
        idea
    else
        code . > /dev/null 2>&1 &
        disown
    end
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

function sdenv
  set -e DENV
  set -gx DENV $argv[1]
  direnv reload
end

function servapi
  redocly --port=10091 --host=0.0.0.0 preview-docs $argv[1] &
  chrome http://0.0.0.0:10091
end

function kservapi
    chp 10091 | rg listen | awk '{ print $2 }' | sudo xargs kill -9
end

function wmock
  java -cp /media/a/data/docs-files/Web/Testing/proxies/wiremock/wiremock/wiremock-jre8-standalone-2.35.0.jar:/media/a/data/docs-files/Web/Testing/proxies/wiremock/wiremock/wiremock-webhooks-extension-2.35.0.jar \
    com.github.tomakehurst.wiremock.standalone.WireMockServerRunner \
    --extensions org.wiremock.webhooks.Webhooks --port $argv[1] --root-dir $argv[2]
end

function structurizr
  java -Djdk.util.jar.enableMultiRelease=false \
    -jar /media/a/data/docs/P/Architecture/best/Software-Architecture-for-Developers/tools/structurizr-lite.war $argv[1]
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
  pip install --upgrade build
  pip install --upgrade wheel
  test -e requirements.txt && pip install -r requirements.txt
  test -e Pipfile && pipenv install --dev
  test -e pyproject.toml && pip install .
  pip install hatch

end

## Kubernetes

function kctrl
  if count $argv > /dev/null
    set podId (kubectl get pods | grep $argv[2] | head -n 1 | awk '{print $1}')
    switch $argv[1]
      case cli
        kubectl exec --stdin --tty $podId -- /bin/bash
      case logs
        kubectl logs $podId -f
      case pf
        kubectl port-forward $podId "$argv[3]:$argv[3]"
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


# test -e .env.local && envsource .env.local
#     test -d code && wezterm cli spawn --cwd code --

function react_to_pwd --on-variable PWD
    type -q deactivate && deactivate
    test -e .venv/bin/activate.fish && source .venv/bin/activate.fish
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

function pinstall
#   pip install --force-reinstall --no-cache-dir -U "$argv[1]" --user
  pip install --force-reinstall --no-cache-dir -U "$argv[1]"
end

function ch
    set dest (_choose-destination)
    cd "$dest"
end
