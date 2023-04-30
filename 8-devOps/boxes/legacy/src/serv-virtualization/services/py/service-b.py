from flask import Flask
import os

app = Flask(__name__)


@app.route('/bye')
def hello():
    return {"type": "spock"}, 200


def get_nomad_assigned_port():
    return os.environ.get('NOMAD_PORT_port_server', 5001)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=get_nomad_assigned_port())
