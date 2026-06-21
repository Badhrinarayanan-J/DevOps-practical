from flask import Flask
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def home():
    return f"""
    <h1>DevOps Practical Demo Application</h1>
    <p>Version: V1</p>
    <p>Current Time: {datetime.now()}</p>
    """

@app.route('/health')
def health():
    return {
        "status": "UP"
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
