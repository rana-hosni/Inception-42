FROM debian:bookworm

RUN apt update && apt install -y mariadb-server mariadb-client && apt clean && apt autoclean

COPY conf/my.conf /etc/mysql/mariadb.conf.d/99-custom.cnf
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 3306

CMD ["/setup.sh"]
