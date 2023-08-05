FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY task6.sh /server/task6.sh

# && apt-get -y install -y gcc libfcgi-dev spawn-fcgi
RUN apt-get update; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    chown -R nginx:nginx /etc/nginx/nginx.conf; \
    chown -R nginx:nginx /var/cache/nginx; \
    # chown -R nginx:nginx /server; \
    touch /var/run/nginx.pid; \
    chown -R nginx:nginx /var/run/nginx.pid;

USER nginx

CMD [ "./server/task6.sh" ]

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1
