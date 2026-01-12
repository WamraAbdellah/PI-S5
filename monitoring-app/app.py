from flask import Flask, request, jsonify, render_template
import datetime

app = Flask(__name__)

# Stockage simple en mémoire (suffisant pour PFE)
alerts = []

@app.route("/api/alert", methods=["POST"])
def receive_alert():
    data = request.json
    data["received_at"] = datetime.datetime.utcnow().isoformat()
    alerts.append(data)

    # 🔔 AFFICHAGE TERMINAL
    print("\n========== 📡 ALERT RECEIVED ==========")
    for k, v in data.items():
        print(f"{k}: {v}")
    print("======================================\n")

    return jsonify({"status": "ok"}), 200

@app.route("/")
def dashboard():
    return render_template("dashboard.html", alerts=alerts[::-1])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
