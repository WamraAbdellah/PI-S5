#!/bin/bash

WATCH_DIR="/honeypot/ransomware/bait"
FILE=".finance_2024.xlsx"

echo "[+] Honeypot ransomware actif"

inotifywait -m "$WATCH_DIR" -e modify,delete,attrib,move |
while read path action file; do
    if [[ "$file" == "$FILE" ]]; then
        python3 /var/lib/.systemd/hp/agent/send_alert.py "{
            \"honeypot\": \"honeypot-all\",
            \"scenario\": \"ransomware\",
            \"event\": \"file_tampering\",
            \"file\": \"$file\",
            \"action\": \"$action\",
            \"severity\": \"critical\"
        }"
    fi
done
