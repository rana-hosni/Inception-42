# inception/
# │
# ├── Makefile
# ├── README.md
# ├── .env
# │
# └── srcs/
#     │
#     ├── docker-compose.yml
#     │
#     └── requirements/
#         │
#         ├── mariadb/
#         │   ├── Dockerfile
#         │   ├── conf/
#         │   │   └── my.cnf
#         │   └── tools/
#         │       └── setup.sh
#         │
#         ├── wordpress/
#         │   ├── Dockerfile
#         │   ├── conf/
#         │   │   └── www.conf
#         │   └── tools/
#         │       └── setup.sh
#         │
#         └── nginx/
#             ├── Dockerfile
#             ├── conf/
#             │   └── nginx.conf
#             └── tools/
#                 └── setup.sh


# COMPOSE = docker compose -f srcs/docker-compose.yml

all:
    docker compose -f ./srcs/docker-compose.yml up --build

down:
    docker compose -f ./srcs/docker-compose.yml down

clean: down
    docker system prune -a

fclean: clean
    docker volume prune -f
    docker network prune -f

re: fclean all