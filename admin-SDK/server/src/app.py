# This is the url of the flask app being stored on gcloud
# https://youtube_darker-adminsdk-cul42mrqdq-uc.a.run.app


from os import error
from firebase_admin import _DEFAULT_APP_NAME
from flask import Flask, request, jsonify
import firebase_admin
import os
import subprocess
from github import Github

app = Flask(__name__)


@app.route("/")
def index():
    return "Hello world"


@app.route("/api/sherlock/<username>", methods=["GET"])
# runs a terminal command that calls the sherlock module
def sherlock(username):
    dict = {}
    cwd = os.getcwd()
    command = ["python3 sherlock", "--site instagram"]
    if "sherlock" not in cwd:
        if "static" & "server" not in cwd:
            os.chdir("/server/static/sherlock")
        os.chdir("sherlock")
    username = str(username)
    terminal_output = subprocess.check_output(
        command[0] + " " + username + " " + command[1], shell=True
    )
    response = str(terminal_output)
    dict["resposne"] = response
    return jsonify(dict)


@app.route("/firebaseinit")
# initializes firebase on the server
def firebaseinit():
    try:
        default_app = firebase_admin.initialize_app
        return default_app.name
    except error:
        return error


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))

# TODO Create a github issue requesst handler
# token df19332ea872ab6ad2820c002befcb8b7df85f9b
# client id c8767771700e5e7a06d2
# client secret 12e602ac75f8018e01127f32c2abc87546b50532
