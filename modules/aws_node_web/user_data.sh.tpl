#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

dnf update -y
dnf install -y nodejs20

mkdir -p /opt/app
echo '${index_html_b64}' | base64 -d > /opt/app/index.html
echo '${server_js_b64}' | base64 -d > /opt/app/server.js

cat > /etc/systemd/system/nodeapp.service <<'UNIT'
[Unit]
Description=Static calculator (Node)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/app
Environment=PORT=${app_port}
ExecStart=/usr/bin/node /opt/app/server.js
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable nodeapp
systemctl restart nodeapp
