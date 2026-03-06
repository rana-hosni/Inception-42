# USER DOCUMENTATION

## 1. Overview

This project deploys a web infrastructure using Docker containers.  
The stack provides a complete WordPress website running with the following services:

- **Nginx** – Web server that handles HTTPS requests.
- **WordPress** – Content management system used to host the website.
- **MariaDB** – Database used by WordPress to store site data.

All services are containerized and orchestrated using Docker Compose.

---

## 2. Starting the Project

To start the project, run the following command in the project root directory:

```bash
make
```
## Access the website:

   ``` open
   WordPress site: https://localhost or
   https://relgheit.42.fr
   ```

## Stop the containers:
   ```
   or make down
```
## Delete images:
```
make clean
or
make fclean (Delete network and volumes)
```

## 3. Managing Credentials

Credentials are stored in environment variables and/or .env files.

Typical credentials include:
```
Database name

Database user

Database password

Domain name
```
These values are used automatically when containers start.

Administrators can update them by modifying the .env file and restarting the project.

## 4. Verifying Services:
```
Docker ps
```
You should see containers for: nginx-wordpress-mariadb

## Check logs:
```
docker logs nginx
docker logs wordpress
docker logs mariadb
```