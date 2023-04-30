from jinja2 import Environment, FileSystemLoader

import sys
import os
import subprocess

env = Environment(
    loader=FileSystemLoader(searchpath=os.getenv("nomad_working_dir")),
    trim_blocks=True, lstrip_blocks=True
)

template = env.get_template(sys.argv[1])

params = os.environ
res = template.render(
    **params
)
proc = subprocess.Popen(["nomad", "job", "run", "-"], stdin=subprocess.PIPE)
msg = str.encode(str(res) + "\n")

# print(f"SENDING: {msg}")

out, err = proc.communicate(msg)
