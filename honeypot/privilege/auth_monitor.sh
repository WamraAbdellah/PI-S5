#!/bin/bash

LOG_FILE="/var/log/auth.log"
touch $LOG_FILE
chmod 644 $LOG_FILE

echo "[+] Honeypot escalade de privilèges actif"

tail -F $LOG_FILE | while read line; do
    if echo "$line" | grep -Ei "backup_admin"; then
        python3 /var/lib/.systemd/hp/agent/send_alert.py "{
            \"honeypot\": \"honeypot-all\",
            \"scenario\": \"privilege_escalation\",
            \"event\": \"auth_activity\",
            \"log\": \"$line\",
            \"severity\": \"high\"
        }"
    fi
done
