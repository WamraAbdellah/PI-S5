import sys
import json
import requests
import datetime

payload = json.loads(sys.argv[1])
payload["timestamp"] = datetime.datetime.utcnow().isoformat()

#  AFFICHAGE TERMINAL (OBLIGATOIRE POUR DEBUG & DEMO)
print("\n==========  ALERT DETECTED  ==========")
for k, v in payload.items():
    print(f"{k}: {v}")
print("=========================================\n")

#  Envoi vers monitoring (optionnel / futur)
try:
    requests.post(
        "http://monitoring:5000/api/alert",
        json=payload,
        timeout=3
    )
except Exception as e:
    print("[INFO] Monitoring server unreachable (normal for now)")
