FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dépendances système
RUN apt update && apt install -y \
    inotify-tools \
    sudo \
    openssh-server \
    rsyslog \
    python3 \
    python3-requests \
    python3-flask \
    curl \
    && apt clean

# SSH runtime
RUN mkdir /var/run/sshd

# Activer logs SSH & PAM
RUN sed -i 's/#LogLevel INFO/LogLevel VERBOSE/' /etc/ssh/sshd_config \
    && sed -i 's/#auth,authpriv.*/auth,authpriv.*    \/var\/log\/auth.log/' /etc/rsyslog.conf

# Comptes
# Escalade (verrouillé → tentative détectable)
RUN useradd -m backup_admin \
    && echo "backup_admin:ChangeMe123" | chpasswd \
    && passwd -l backup_admin

# SSH appât
RUN useradd -m ssh_test \
    && echo "ssh_test:123456" | chpasswd

# Création temporaire des dossiers honeypot
RUN mkdir -p /honeypot/ransomware/bait \
    /honeypot/privilege \
    /honeypot/ssh \
    /honeypot/web \
    /honeypot/agent

# Fichier ransomware invisible
RUN touch /honeypot/ransomware/bait/.finance_2024.xlsx \
    && chmod 444 /honeypot/ransomware/bait/.finance_2024.xlsx

# Copier le projet
WORKDIR /honeypot
COPY ransomware/ ransomware/
COPY privilege/ privilege/
COPY ssh/ ssh/
COPY web/ web/
COPY agent/ agent/
COPY supervisor.sh .

# Rendre exécutables
RUN chmod +x supervisor.sh \
    ransomware/monitor.sh \
    privilege/auth_monitor.sh \
    ssh/ssh_monitor.sh

# DISSIMULATION DU HONEYPOT
# Déplacement dans un dossier système discret + permissions root only
RUN mkdir -p /var/lib/.systemd \
    && mv /honeypot /var/lib/.systemd/hp \
    && chown -R root:root /var/lib/.systemd \
    && chmod -R 700 /var/lib/.systemd

# Dossier de travail neutre (attaquant)
WORKDIR /root

CMD ["/var/lib/.systemd/hp/supervisor.sh"]
