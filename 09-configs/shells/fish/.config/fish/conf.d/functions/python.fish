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
    #     pip install --upgrade build
    #     pip install --upgrade wheel
    #     pip install --upgrade hatch
    #     pip install --upgrade flake8

    # pip install --upgrade pyhumps
    #   pip install --upgrade twine
    #   pip install --upgrade setuptools

    #   pip install devpi-client

    test -e requirements.txt && echo "Installing a requirements.txt ******>>>" && pip install -r requirements.txt
    test -e requirements-dev.txt && echo "Installing a requirements-dev.txt ******>>>" && pip install -r requirements-dev.txt
    test -e Pipfile && echo "Installing a Pipfile ******>>>" && pipenv install --dev
    test -e pyproject.toml && echo "Installing a pyproject.toml ******>>>" && pip install .

end
