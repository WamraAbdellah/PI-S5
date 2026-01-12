#!/bin/bash

HP=/var/lib/.systemd/hp

echo "[+] Honeypot ALL démarré (stealth mode)"

echo "[+] Starting rsyslog"
rsyslogd

echo "[+] Starting SSHD"
/usr/sbin/sshd -D &

sleep 2

echo "[+] Starting ransomware monitor"
$HP/ransomware/monitor.sh &

echo "[+] Starting privilege escalation monitor"
$HP/privilege/auth_monitor.sh &

echo "[+] Starting SSH monitor"
$HP/ssh/ssh_monitor.sh &

echo "[+] Starting web honeypot"
python3 $HP/web/app.py &

wait
