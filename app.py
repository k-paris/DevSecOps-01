from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)


@app.route("/")
def index():
    return "DevSecOps lab"


@app.route("/hello")
def hello():
    name = request.args.get("name", "world")
    return render_template("hello.html", name=name)


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")

    result = subprocess.run(
        ["ping", "-c", "1", host],
        capture_output=True,
        text=True,
        check=False,
    )

    return result.stdout

if __name__ == "__main__":
    # Containerized application: Docker controls external exposure.
    app.run(host="0.0.0.0", port=8080)  # nosemgrep: python.flask.security.audit.app-run-param-config.avoid_app_run_with_bad_host
