FROM nginx:1.19.6

ARG USER_NAME
ARG PASSWORD

RUN apt-get update && apt-get install -y openssl && \
    echo "${USER_NAME}:`openssl passwd -crypt ${PASSWORD}`" >> /etc/nginx/.htpasswd

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
