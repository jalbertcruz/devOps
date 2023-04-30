
from flask import Flask, request
import os


class WHook:

    app = Flask(__name__)

    @app.route("/critical", methods=['GET', 'POST'])
    def critical():
        data = request.data
        print("CRITICAL ======================================================================== ")
        print(data)
        return "ok"

    @app.route("/warning", methods=['GET', 'POST'])
    def warning():
        data = request.data
        print("WARNING >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ")
        print(data)
        return "ok"

    app.run(port=int(os.environ["PORT"]), debug=True, host="0.0.0.0")

WHook()
