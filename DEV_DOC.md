
# DEV_DOC.md

```markdown
# DEVELOPER DOCUMENTATION

## 1. Project Overview

This project builds a containerized web infrastructure using:

- Docker
- Docker Compose
- Nginx
- WordPress
- MariaDB

Each service runs inside its own container and communicates through a Docker network.

The goal is to create a reproducible environment that can be built and deployed easily.

---

## 2. Prerequisites

Before running the project, ensure the following tools are installed:

- Docker
- Docker Compose
- Make
- Git

Verify installation:

```bash
docker --version
docker compose version
```

## Project Structure

1. Makefile: Provides convenient commands (make build, make up, make down, etc.) to manage the project.

2. docker-compose.yml: Defines all services, networks, and volumes.

3. requirements/: Contains Dockerfiles and configuration files for each service (Nginx, WordPress, MariaDB, etc.).

4. tools/: Additional scripts or resources (e.g., entrypoint scripts, configuration templates).

5. secrets/: Directory for sensitive files (if used instead of environment variables).
```
inception/
│
├── Makefile
├── README.md
├── .env
│
└── srcs/
    │
    ├── docker-compose.yml
    │
    └── requirements/
        │
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── my.cnf
        │   └── tools/
        │       └── setup.sh
        │
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── www.conf
        │   └── tools/
        │       └── setup.sh
        │
        └── nginx/
            ├── Dockerfile
            ├── conf/
            │   └── nginx.conf
            └── tools/
                └── setup.sh
```
## Build:
```
docker compose up --build
or Make
```
## Container Management:
```
Docker ps

docker logs nginx
docker logs wordpress
docker logs mariadb

docker exec -it <container_name> bash (Enter Container by shell)

Example: (Mariadb)
docker exec  -u root -it  mariadb sh/ mysql -u root -p
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
SELECT * FROM wp_users;
```


## Stopping Containers:
```
make down   -> Stop and remove running containers
make clean  -> Remove project Docker images
make fclean -> Remove containers, images, volumes, and networks
```

## 12. Rebuilding the Project
```
Make re
```