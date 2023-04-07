from flask import Flask, request

app = Flask(__name__)
import requests
import time

from toposort import toposort_flatten


from jinja2 import Environment, FileSystemLoader

import sys
import os
import subprocess

searchpath = os.getenv("NOMAD_WORKING_DIR", os.path.join(os.path.abspath(os.path.dirname(__file__)), "../.."))

env = Environment(
    loader=FileSystemLoader(searchpath=searchpath),
    trim_blocks=True, lstrip_blocks=True
)

global_consul_ip = "172.17.0.2"
global_consul_ip = "172.16.10.65"
# global_consul_ip = "localhost"
consul_address = "localhost"
consul_address = "172.17.0.2"
consul_address = "172.16.10.65"

nomad_address = "172.16.10.65"


# curl -G http://localhost:8500/v1/agent/services --data-urlencode 'filter=Service == wiremock'

@app.route('/services', methods=["POST"])
def services():
    print("******** -------------------------- ====================================")
    print(request.json)
    return {"state": "ok"}, 200


def update_ports():
    services_data = requests.get(f"http://{consul_address}:8500/v1/agent/services").json()

    for v in services_data.values():
        response = requests.put(f"http://{global_consul_ip}:8500/v1/kv/service-port-{v['Service']}",
                                data=str.encode(str(v['Port'])))


@app.route('/deploy', methods=["POST"])
def deployment():
    deps = request.json

    waiting_dict = {x: y for (x, y) in deps.items() if type(y) is int}
    deps = [(x, y) for (x, y) in deps.items() if type(y) is list]
    deps = dict(deps)

    deps = {k: set(v) for k, v in deps.items()}

    # print(list(toposort_flatten(deps)))
    new_services = list(toposort_flatten(deps))

    req = requests.get(f"http://{consul_address}:8500/v1/agent/services")
    req = req.json()
    existing_services = []
    for k, v in req.items():
        if "Service" in v.keys():
            existing_services.append(v["Service"])

    existing_services = set(existing_services)

    new_services = [service for service in new_services if service.split('/')[-1] not in existing_services]

    # python cli/run-nomad-job.py "${filename}"
    for service in new_services:
        template_name = f"dev/{service}.nomad-job.template"
        template = env.get_template(template_name)

        params = os.environ
        res = template.render(
            **params
        )
        # proc = subprocess.Popen(["nomad", "job", "run", "-"], stdin=subprocess.PIPE)
        proc = subprocess.Popen(["nomad", "job", "run", "-address", f"http://{nomad_address}:4646", "-"], stdin=subprocess.PIPE)
        msg = str.encode(str(res) + "\n")

        # nomad job run -address http://172.16.10.65:4646 /home/a/src/devOps/nomad/dev/mss/redis.nomad-job.template
        # nomad job run -address http://172.16.10.65:4646 /home/a/src/devOps/nomad/dev/mss/logging/prom.nomad-job.template

        # print(f"SENDING: {msg}")
        # open("msg.json", "w").write(str(res))

        out, err = proc.communicate(msg)

        time.sleep(5)

        update_ports()

        wtime = waiting_dict.get(service, None)
        if wtime:
            time.sleep(wtime)

    return {"state": "ok"}, 200


if __name__ == '__main__':
    app.run(port=5005, debug=False, host="0.0.0.0")
    # app.run(port=5000, debug=True, host="0.0.0.0")
