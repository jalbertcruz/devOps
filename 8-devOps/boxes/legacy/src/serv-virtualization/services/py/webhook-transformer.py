from flask import Flask, request
import os
import requests
import random

app = Flask(__name__)

from jinja2 import Environment, FileSystemLoader

loader = FileSystemLoader("/templates")

env = Environment(
    loader=loader,
    trim_blocks=True,
    lstrip_blocks=True,
)


@app.route('/disbursement/v1_0/transfer', methods=["POST"])
def mtn_transfer():
    params = {
        "x_callback_url": request.headers.get('X-Callback-Url'),
        "x_reference_id": request.headers.get('X-Reference-Id'),
    }
    print(f"1-------------------------------------------------\n--------------------------------------\n{params}")
    # print(env.get_template("mtn_transfer_get.json").render(**params))
    # print(f"x-------------------------------------------------\n--------------------------------------\n")

    response = requests.post("http://wiremock.service.dc1.consul/__admin/mappings/new",
                             data=env.get_template("mtn_transfer_get.json").render(**params))

    response_callback_json = "mtn_transfer.json"
    if random.random() > 0.5:
        response_callback_json = "mtn_transfer_error.json"

    response = requests.post(f"http://wiremock-webhook.service.dc1.consul/__admin/mappings/new",
                             data=env.get_template(response_callback_json).render(**params))

    print(f"x-------------------------------------------------\n--------------------------------------\n")
    print(env.get_template("mtn_transfer.json").render(**params))
    print(response.status_code)
    print(response.content)
    print(f"y-------------------------------------------------\n--------------------------------------\n")

    response = requests.post(f"http://wiremock-webhook.service.dc1.consul/disbursement/v1_0/transfer",
                             data=request.json, headers=request.headers)

    print(request.json)
    return {"name": "ana"}, 200


def get_nomad_assigned_port():
    return os.environ.get('NOMAD_PORT_port_server', 5001)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=get_nomad_assigned_port())
