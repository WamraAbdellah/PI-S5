from flask import Flask, request
import re
import json
import subprocess

app = Flask(__name__)

def suspicious(payload):
    patterns = [
        r"'|--|;|OR|AND",
        r"<script>",
        r"\.\./",
        r"\$\("
    ]
    return any(re.search(p, payload, re.IGNORECASE) for p in patterns)

@app.route("/search")
def search():
    q = request.args.get("q", "")

    if suspicious(q):
        alert = {
            "honeypot": "honeypot-all",
            "scenario": "web_attack",
            "payload": q,
            "severity": "high"
        }

        # APPEL SÉCURISÉ (PAS DE SHELL)
        subprocess.run(
            [
                "python3",
                "/var/lib/.systemd/hp/agent/send_alert.py",
                json.dumps(alert)
            ],
            check=False
        )

    return f"Résultat pour : {q}"

app.run(host="0.0.0.0", port=8080)
