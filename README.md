*This project has been created as part of the 42 curriculum by relgheit .*

# Description

This project aims to deepen understanding of system administration and Docker by setting up a small infrastructure composed of several services. The entire application is containerized using Docker Compose, ensuring consistency across different environments and simplifying deployment.

The infrastructure includes:
- A **MariaDB** database for persistent data storage.
- A **WordPress** instance running PHP-FPM for serving dynamic content.
- An **Nginx** web server configured with TLSv1.2 or TLSv1.3 to handle HTTPS requests and serve static files.
- A **static website** served by its own Nginx container to demonstrate multi-container setups.

The project emphasizes security, separation of concerns, and adherence to best practices in containerization. All services are defined in a `docker-compose.yml` file and are configured to run in isolated containers, communicating through dedicated networks.

# Instructions

## Prerequisites
- Docker and Docker Compose must be installed on the host machine.
- Make sure the ports used by the services (443 for HTTPS) are free.

## Setup
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd <repository_name>
   Make
   ```

## Access the website:

   ``` open
   WordPress site: https://localhost or
   https://relgheit.42.fr
   ```

## Stop the containers:
   ```
   docker-compose down
   or make down
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
## Use of AI:
AI assistance was used in the following aspects of the project:

Education: Understanding concepts and searching for quick answers when information was not clear in the official documentation.

Debugging: Identifying and fixing configuration errors in Nginx, PHP-FPM, and MariaDB setups.

Documentation: Refining and reviewing the project documentation.

# Resources:
```
https://docs.docker.com/
https://nginx.org/
https://mariadb.org/documentation/
https://aws.amazon.com/compare/the-difference-between-mariadb-vs-mysql/
https://developer.wordpress.org/
```
