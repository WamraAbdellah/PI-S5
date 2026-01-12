#!/bin/bash

LOG_FILE="/var/log/auth.log"

echo "[+] Honeypot SSH actif"

tail -F $LOG_FILE | while read line; do
    if echo "$line" | grep -E "ssh_test|Failed password"; then
        python3 /var/lib/.systemd/hp/agent/send_alert.py "{
            \"honeypot\": \"honeypot-all\",
            \"scenario\": \"ssh_bruteforce\",
            \"log\": \"$line\",
            \"severity\": \"medium\"
        }"
    fi
done
