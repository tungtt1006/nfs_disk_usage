FROM nginx:stable-alpine3.17

RUN apk add --update --no-cache bash

USER root

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY ./crontab /root/crontab

COPY ./scripts/ /root/scripts/

RUN chmod 774 -R /root/scripts && \
    crontab /root/crontab

ENV DIRECTORY=/root/nfs-storage METRICS_FILE_PATH=/usr/share/nginx/metrics

CMD ["/bin/bash", "/root/scripts/entrypoint.sh"]
