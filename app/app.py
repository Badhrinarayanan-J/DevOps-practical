from flask import Flask, Response
from datetime import datetime
from prometheus_client import Counter, generate_latest
from prometheus_client import CONTENT_TYPE_LATEST

app = Flask(__name__)

@app.route('/')
def home():
    return f"""
    <h1>DevOps Practical Demo Application</h1>
    <p>Version: V2 - CI/CD Test</p>
    <p>Current Time: {datetime.now()}</p>
    """

@app.route('/health')
def health():
    return {
        "status": "UP"
    }


@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
