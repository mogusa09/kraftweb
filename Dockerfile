FROM alpine:3.24
RUN apk add --no-cache nginx unzip ca-certificates
ADD https://github.com/XTLS/Xray-core/releases/download/v26.11.9/Xray-linux-64.zip /tmp/xray.zip
RUN unzip /tmp/xray.zip -d /tmp/xray && mv /tmp/xray/xray /usr/bin/gateway && chmod +x /usr/bin/gateway && rm -rf /tmp/xray /tmp/xray.zip
COPY nginx.conf /etc/nginx/nginx.conf
COPY homepage.html /www/index.html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /var/log/nginx /var/lib/nginx/tmp/client_body /var/lib/nginx/tmp/proxy /var/lib/nginx/tmp/fastcgi /var/lib/nginx/tmp/uwsgi /var/lib/nginx/tmp/scgi
CMD ["/bin/sh", "/entrypoint.sh"]
