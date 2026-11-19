#!/bin/sh
set -e
if [ -z "$UUID" ]; then
  echo "UUID env var is required" >&2
  exit 1
fi
mkdir -p /etc/gateway /run /var/log/nginx /var/lib/nginx/tmp/client_body /var/lib/nginx/tmp/proxy /var/lib/nginx/tmp/fastcgi /var/lib/nginx/tmp/uwsgi /var/lib/nginx/tmp/scgi
cat > /etc/gateway/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 10086,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "settings": { "clients": [{ "id": "$UUID" }], "decryption": "none" },
      "streamSettings": { "network": "ws", "wsSettings": { "path": "/ws" } }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "settings": {} }]
}
EOF
/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
/usr/sbin/nginx -c /etc/nginx/nginx.conf
exec /usr/bin/gateway -config /etc/gateway/config.json
