FROM debian:bookworm

RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/my.conf /etc/nginx/sites-available/default
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 443

CMD ["/setup.sh"]

# docker run -p 443:443 -e DOMAIN_NAME=localhost my_nginx

