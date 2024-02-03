
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
  test -e requirements-dev.txt && pip install -r requirements-dev.txt
  test -e Pipfile && pipenv install --dev
  test -e pyproject.toml && pip install .
  pip install hatch
#   pip install devpi-client

end
